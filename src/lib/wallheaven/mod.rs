use std::{
    fs,
    io::{stdout, BufRead, Write},
};

use image::{DynamicImage, ImageFormat};
use log::error;
use reqwest::blocking::Client;
use uuid::Uuid;

use crate::{
    metadata::{self, FileMetadata, StorageMetadata},
    wallheaven::structs::{CollectionData, CollectionDataResponse, ImageDetailsResponse},
};

use self::structs::{Collection, CollectionsResponse, ImageDetailsData};

mod client;
mod structs;

pub fn sync(storage_metadata: &mut StorageMetadata) -> Result<(), String> {
    let client = client::wallman_client()
        .build()
        .map_err(|err| err.to_string())?;

    let collection_response = get_user_collections(&client, "TSear")?;

    println!("{:#?}", collection_response);

    println!("Which collection would You like to sync?");
    for (index, data) in collection_response.data.iter().enumerate() {
        println!("{}: {}", index + 1, data.label);
    }
    print!("Select option: ");
    stdout().flush().expect("Failed to flush");

    let mut user_response = "".to_string();
    std::io::stdin()
        .lock()
        .read_line(&mut user_response)
        .expect("TODO Handle error during input");

    let user_response = user_response
        .trim()
        .parse::<u32>()
        .map_err(|err| err.to_string())?;

    let selected_collection = collection_response
        .data
        .get((user_response - 1) as usize)
        .ok_or("Index out of bounds")?;

    println!("Selected collection: {}", selected_collection.label);

    if selected_collection.count == 0 {
        println!("Selected collection is empty");
        return Ok(());
    }
    let collection_path = storage_metadata.path.join(&selected_collection.label);

    if !collection_path.exists() {
        fs::create_dir(collection_path).expect("Failed to create collection directory");
    }

    let images_in_collection = get_images_in_collection(&client, selected_collection)?;
    let images_details = get_images_details(images_in_collection, &client)?;

    let mut collection = storage_metadata.get_collection_owned(&selected_collection.label);
    let images_not_in_store = get_images_not_in_store(&collection, images_details);

    let mut buffer: Vec<(DynamicImage, FileMetadata)> = Vec::with_capacity(3);

    for entry in images_not_in_store {
        let image = match get_image_from_url(&client, &entry.path) {
            Ok(value) => value,
            Err(err) => {
                error!("{}", err);
                continue;
            }
        };

        let tags = entry.tags.iter().map(|tag| tag.name.to_string()).collect();

        let new_image_metadata = FileMetadata {
            id: Uuid::new_v4(),
            url: Some(entry.path),
            resolution: Some((image.width(), image.height())),
            permalink: Some(entry.url),
            tags,
            ..FileMetadata::default()
        };

        buffer.push((image, new_image_metadata));

        if buffer.len() == 3 {
            persist_buffer(&mut buffer, storage_metadata, &mut collection);
        }
    }

    persist_buffer(&mut buffer, storage_metadata, &mut collection);

    storage_metadata.collections.push(collection);

    Ok(())
}

fn get_user_collections(client: &Client, username: &str) -> Result<CollectionsResponse, String> {
    let request_builder = client.get(format!(
        "https://wallhaven.cc/api/v1/collections/{}",
        username
    ));

    let collection_response = client::limited_get(client, request_builder)?;

    collection_response
        .json::<CollectionsResponse>()
        .map_err(|err| err.to_string())
}

fn get_images_in_collection(
    client: &Client,
    collection: &Collection,
) -> Result<Vec<CollectionData>, String> {
    let mut images_in_collection: Vec<CollectionData> = vec![];
    let mut index = 1;
    let mut pages = 1;

    while index <= pages {
        let images_in_collection_request = client.get(format!(
            "https://wallhaven.cc/api/v1/collections/TSear/{}?page={}",
            collection.id, index
        ));

        let mut images_in_collection_response =
            client::limited_get(client, images_in_collection_request)?
                .json::<CollectionDataResponse>()
                .map_err(|err| err.to_string())?;

        for entry in images_in_collection_response.data.drain(..) {
            images_in_collection.push(entry);
        }

        pages = images_in_collection_response.meta.last_page;
        index += 1;
    }

    Ok(images_in_collection)
}

fn get_images_details(
    collection_data: Vec<CollectionData>,
    client: &Client,
) -> Result<Vec<ImageDetailsData>, String> {
    let mut images_details_mut = Vec::with_capacity(collection_data.len());
    for entry in collection_data {
        let image_details_request =
            client.get(format!("https://wallhaven.cc/api/v1/w/{}", entry.id));

        let image_details_response = client::limited_get(client, image_details_request)?
            .json::<ImageDetailsResponse>()
            .map_err(|err| err.to_string())?;

        images_details_mut.push(image_details_response.data);
    }
    Ok(images_details_mut)
}

fn persist_buffer(
    buffer: &mut Vec<(DynamicImage, FileMetadata)>,
    storage_metadata: &StorageMetadata,
    collection: &mut metadata::Collection,
) {
    println!("Persisting buffer");
    for (image, new_metadata) in buffer.drain(..) {
        let image_format = image::guess_format(image.as_bytes()).unwrap_or(ImageFormat::Jpeg);
        let absolute_file_path = storage_metadata.path.join(&collection.label).join(format!(
            "{}.{}",
            new_metadata.id,
            image_format.extensions_str()[0]
        ));

        println!("{:?}", absolute_file_path);
        collection.index.push(new_metadata);
        image.save(absolute_file_path).unwrap();
    }
    collection.persist_collection(storage_metadata);
}

fn get_images_not_in_store(
    collection: &metadata::Collection,
    mut images_details: Vec<ImageDetailsData>,
) -> Vec<ImageDetailsData> {
    images_details.retain(|entry| {
        !collection
            .index
            .iter()
            .filter(|index_entry| index_entry.url.is_some())
            .any(|index_entry| *index_entry.url.as_ref().unwrap() == entry.path)
    });

    images_details
}

fn get_image_from_url(client: &Client, url: &str) -> Result<DynamicImage, String> {
    let request_builder = client.get(url);

    let image_response = client::limited_get(&client, request_builder);

    let image_response = image_response?;

    let bytes = image_response.bytes().map_err(|err| err.to_string())?;

    image::load_from_memory(&bytes).map_err(|err| err.to_string())
}
