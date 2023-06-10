use std::io::{stdout, BufRead, Write};

use reqwest::blocking::Client;

use crate::wallheaven::structs::{CollectionData, CollectionDataResponse, ImageDetailsResponse};

use self::structs::{Collection, CollectionsResponse, ImageDetailsData};

mod client;
mod structs;

pub fn sync() -> Result<(), String> {
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

    let images_in_collection = get_images_in_collection(&client, selected_collection)?;

    println!("{:#?}", images_in_collection);

    let images_details = get_images_details(images_in_collection, &client);

    println!("{:#?}", images_details);

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
