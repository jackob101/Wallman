use crate::env_config::EnvConfig;
use crate::metadata::{Collection, FileMetadata, StorageMetadata};

use crate::reddit::client::ClockedClient;
use crate::reddit::structs::PostInformations;
use crate::{prompts, reddit, storage, utils};

use crate::simple_file::SimpleFile;
use std::fs::DirEntry;
use std::io::{BufRead, Write};
use std::sync::mpsc::{self, SyncSender};

use image::imageops::FilterType;
use image::{DynamicImage, ImageFormat};

use log::{error, info};
use reqwest::blocking;

use std::path::{Path, PathBuf};
use std::{collections, fs, io};
use uuid::Uuid;

pub fn fix_storage(
    config: &EnvConfig,
    storage_metadata: &mut Option<StorageMetadata>,
    collection_label: String,
) -> Result<(), String> {
    let Some(storage_metadata) = storage_metadata else {
        return Err(crate::INDEX_NOT_INITIALIZED_ERROR.to_string());
    };

    let stored_files = get_indexed_files_from_directory(&config.storage_directory);

    let Some(collection) = storage_metadata.get_collection_mut(&collection_label) else{
    return Err(format!("Collection with label {} was not found", collection_label));
};

    collection.index.retain(|file_metadata| {
        let does_file_with_id_exists = stored_files
            .iter()
            .any(|entry| entry.index == file_metadata.id);

        let does_id_have_tags = !file_metadata.tags.is_empty();

        does_file_with_id_exists && does_id_have_tags
    });

    Ok(())
}

pub fn init_storage(config: &EnvConfig, collection_label: &str) {
    let collection_dir = config.storage_directory.join(collection_label);
    fs::create_dir(&collection_dir).expect("Failed to create collection dir");
    fs::write(collection_dir.join("index.json"), "[]").expect("Failed to initialize index.json");
}

pub fn delete(ids: &[Uuid], config: &EnvConfig) -> Result<Vec<Uuid>, String> {
    let mut removed_ids: Vec<Uuid> = vec![];

    let files_iterator = fs::read_dir(&config.storage_directory)
        .map_err(|_| "Failed to read files from directory")?;

    for file in files_iterator {
        let file = match file {
            Ok(value) => value,
            Err(err) => {
                println!("Failed to read file: {}", err);
                continue;
            }
        };

        let file_id = match get_file_id(&file) {
            None => {
                println!("Skipping: {}", file.path().display());
                continue;
            }
            Some(value) => value,
        };

        if !ids.contains(&file_id) {
            continue;
        }

        let file_path = config.storage_directory.join(file.path());

        match get_confirmation_for_file_deletion_from_user(&file_path) {
            true => match fs::remove_file(file_path) {
                Ok(_) => {
                    println!("File removed successfully");
                    removed_ids.push(file_id);
                }
                Err(err) => println!("{}", err),
            },
            false => {
                println!("Skipping");
            }
        }
    }

    Ok(removed_ids)
}

pub fn download(url: &str, config: &EnvConfig) -> SimpleFile {
    info!("Downloading from url: {}", url);

    let file_from_url = blocking::get(url)
        .expect("Unexpected error during file download")
        .bytes()
        .unwrap();

    let image_format =
        image::guess_format(&file_from_url).expect("Couldn't determine default file extension");

    let next_id = Uuid::new_v4();
    let image_file = SimpleFile::new(next_id, image_format);
    let absolute_file_path = &config.storage_directory.join(image_file.to_path());

    image::load_from_memory(&file_from_url)
        .unwrap()
        .save(absolute_file_path)
        .unwrap();

    image_file
}

pub fn download_bulk(
    posts_informations: Vec<PostInformations>,
    config: &EnvConfig,
    storage_metadata: &mut StorageMetadata,
) -> Result<(), String> {
    println!("Starting bulk download");

    let mut already_present_in_storage_count = 0;
    let mut saved_files = 0;
    let mut skipped_images_count = 0;

    let collection = storage_metadata
        .get_collection(&"reddit".to_string())
        .expect("TMP");

    let new_posts_informations: Vec<PostInformations> = {
        let mut new_posts_informations_mut: Vec<PostInformations> = vec![];
        for post_informations in posts_informations {
            let Ok(filename_from_url) = utils::extract_filename_from_url(&post_informations.image_url) 
            else{
                continue;
            };

            let does_file_already_exists_in_storage_metadata = collection
                .index
                .iter()
                .filter_map(|file_from_storage| file_from_storage.url_filename.as_ref())
                .any(|file_from_storage| file_from_storage.eq(filename_from_url));

            if does_file_already_exists_in_storage_metadata {
                already_present_in_storage_count += 1;
                continue;
            };

            new_posts_informations_mut.push(post_informations);
        }
        new_posts_informations_mut
    };

    let (tx, rx) = mpsc::sync_channel::<(PostInformations, DynamicImage)>(3);

    std::thread::spawn(|| fetch_images(new_posts_informations, tx));

    let mut buffer: Vec<(DynamicImage, FileMetadata)> = Vec::with_capacity(3);

    loop {
        let (post_informations, image) = match rx.try_recv() {
            Ok(value) => value,
            Err(err) => match err {
                mpsc::TryRecvError::Empty => continue,
                mpsc::TryRecvError::Disconnected => break,
            },
        };

        //TODO: This is not portable
        std::process::Command::new("clear")
            .status()
            .expect("Failed to execute clear");

        utils::print(&image);

        if !prompts::ask_for_confirmation_to_save_image() {
            println!("Skipping image");
            skipped_images_count += 1;
            continue;
        }

        let additional_tags = prompts::ask_for_additional_tags().into_iter().collect();
        let user_picked_resolution = prompts::ask_for_resolution(image.width(), image.height());

        info!("{:?}", user_picked_resolution);

        let resized_image = if user_picked_resolution == (image.width(), image.height()) {
            image
        } else {
            image.resize(
                user_picked_resolution.0,
                user_picked_resolution.1,
                image::imageops::FilterType::Triangle,
            )
        };

        let new_image_metadata = FileMetadata {
            resolution: Some((resized_image.width(), resized_image.height())),
            permalink: Some(post_informations.permalink.to_string()),
            id: Uuid::new_v4(),
            tags: additional_tags,
            url_filename: utils::extract_filename_from_url(&post_informations.image_url)
                .map(|e| e.to_string())
                .ok(),
            url: Some(post_informations.image_url),
        };

        buffer.push((resized_image, new_image_metadata));

        if buffer.len() == 3 {
            persist_buffer(&mut buffer, config, storage_metadata);
        }

        saved_files += 1;
    }

    std::process::Command::new("clear")
        .status()
        .expect("Failed to execute clear");

    println!(
        "Images already present in storage: {}",
        already_present_in_storage_count
    );
    println!("New images saved: {}", saved_files);
    println!("Skipped images: {}", skipped_images_count);

    Ok(())
}

pub fn restore(
    storage_metadata: &StorageMetadata,
    config: &EnvConfig,
    collection_label: String,
) -> Result<(), String> {
    let Some(collection) = storage_metadata.get_collection(&collection_label) else{
        return Err(format!("Collection with label: {} was not found", collection_label));
    };

    let client = reqwest::blocking::Client::builder()
        .user_agent(reddit::APP_USER_AGENT)
        .build()
        .expect("Failed to create request client");

    let images_in_storage = get_indexed_files_from_directory(&config.storage_directory);

    for file_metadata in &collection.index {
        let Some(image_url) =  &file_metadata.url else{
           continue; 
        };

        let is_file_already_in_storage = images_in_storage
            .iter()
            .any(|entry| entry.index == file_metadata.id);

        if is_file_already_in_storage {
            continue;
        }

        let response = client.get(image_url).send();

        let response = match response {
            Ok(value) => value,
            Err(err) => {
                error!(
                    "Failed to download image from URL: {}. Err {}",
                    image_url, err
                );
                continue;
            }
        };

        let bytes = match response.bytes() {
            Ok(value) => value,
            Err(err) => {
                error!("Failed to get image Err {}", err);
                continue;
            }
        };

        let image = match image::load_from_memory(&bytes) {
            Ok(value) => value,
            Err(err) => {
                error!("Failed to convert bytes to image: {}", err);
                continue;
            }
        };

        let image = match file_metadata.resolution {
            Some((width, height)) if width == image.width() && height == image.height() => image,
            Some((width, height)) => image.resize(width, height, FilterType::Triangle),
            None => image,
        };

        let image_format = image::guess_format(image.as_bytes()).unwrap_or(ImageFormat::Jpeg);

        image
            .save(
                config
                    .storage_directory
                    .join(utils::format_filename_and_extension(
                        &file_metadata.id.to_string(),
                        image_format,
                    )),
            )
            .expect("Failed to save image");
    }
    Ok(())
}

fn fetch_images(
    posts_informations: Vec<PostInformations>,
    tx: SyncSender<(PostInformations, DynamicImage)>,
) {
    let request_client = reqwest::blocking::Client::builder()
        .user_agent(reddit::APP_USER_AGENT)
        .build()
        .expect("Failed to create request client");

    for post_informations in posts_informations {
        let response = request_client
            .get(post_informations.image_url.to_string())
            .send();

        let response = match response {
            Ok(value) => value,
            Err(err) => {
                error!(
                    "Failed to download image from URL: {}. Err {}",
                    post_informations.image_url, err
                );
                continue;
            }
        };

        let bytes = match response.bytes() {
            Ok(value) => value,
            Err(err) => {
                error!("Failed to get image Err {}", err);
                continue;
            }
        };

        let image = match image::load_from_memory(&bytes) {
            Ok(value) => value,
            Err(err) => {
                error!("Failed to convert bytes to image: {}", err);
                continue;
            }
        };

        info!("Fetched new image");

        match tx.send((post_informations, image)) {
            Ok(_) => (),
            Err(err) => error!("{}", err),
        };
    }
}

fn get_file_id(file: &DirEntry) -> Option<Uuid> {
    let file_path = file.path();

    let file_stem = match file_path.file_stem() {
        None => return None,
        Some(value) => value,
    };

    let file_stem = match file_stem.to_str() {
        None => return None,
        Some(value) => value,
    };

    match file_stem.parse::<Uuid>() {
        Ok(parsed_id) => Some(parsed_id),
        Err(_) => None,
    }
}

fn get_confirmation_for_file_deletion_from_user(file_path: &Path) -> bool {
    println!(
        "Removing {}",
        &file_path.to_str().expect("Failed to parse path to str")
    );

    loop {
        print!("Please confirm [Y/N]: ");
        io::stdout().flush().expect("Failed to flush");
        let mut input = String::new();
        io::stdin()
            .lock()
            .read_line(&mut input)
            .expect("Unexpected error during reading user input");
        input = input.trim().to_string();

        if input == "y" || input == "Y" {
            return true;
        } else if input == "N" || input == "n" {
            return false;
        }
    }
}

fn get_indexed_files_from_directory_in_order(path: &PathBuf) -> Vec<SimpleFile> {
    let mut current_files: Vec<SimpleFile> = get_indexed_files_from_directory(path);

    current_files.sort_by(|x, x1| x.index.cmp(&x1.index));

    current_files
}

///
/// Indexed files are the ones with ID and file extension for example: 1.png, 2.jpg
///
fn get_indexed_files_from_directory(path: &PathBuf) -> Vec<SimpleFile> {
    let mut current_files: Vec<SimpleFile> = vec![];

    for entry in fs::read_dir(path).unwrap() {
        let entry = entry.unwrap();
        let path = entry.path();
        if !path.is_file() {
            continue;
        }

        let file_name = path
            .file_stem()
            .map(|name| name.to_str().expect("File name is not a valid UTF-8"))
            .unwrap_or_else(|| "0");

        let file_name_prefix = file_name.split('.').next();

        if file_name_prefix.is_none() {
            continue;
        }

        match file_name_prefix.unwrap().parse::<Uuid>() {
            Ok(value) => {
                let format = ImageFormat::from_extension(path.extension().expect("Missing format"))
                    .expect("");
                current_files.push(SimpleFile::new(value, format));
            }
            Err(_) => continue,
        }
    }

    current_files
}

fn persist_buffer(
    buffer: &mut Vec<(DynamicImage, FileMetadata)>,
    config: &EnvConfig,
    storage_metadata: &mut StorageMetadata,
) {
    println!("Persisting buffer");
    for (image, new_metadata) in buffer.drain(..) {
        let image_format = image::guess_format(image.as_bytes()).unwrap_or(ImageFormat::Jpeg);
        let absolute_file_path = config.storage_directory.join("reddit").join(format!(
            "{}.{}",
            new_metadata.id,
            image_format.extensions_str()[0]
        ));

        //TODO: Remove unwraping after https://trello.com/c/MJlIAvnG/4-storagemetadata
        storage_metadata
            .get_collection_mut("reddit")
            .expect("")
            .index
            .push(new_metadata);
        image.save(absolute_file_path).unwrap();
    }
    storage_metadata.persist();
}
