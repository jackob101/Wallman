use crate::env_config::EnvConfig;
use crate::metadata::{FileMetadata, StorageMetadata};

use crate::reddit::structs::PostInformations;
use crate::{prompts, reddit, utils, INDEX_NOT_INITIALIZED_ERROR};

use crate::simple_file::SimpleFile;
use std::fs::DirEntry;
use std::io::{BufRead, Write};
use std::sync::mpsc::{self, SyncSender};

use image::{DynamicImage, ImageFormat};
use libc::utime;
use log::{error, info};
use reqwest::blocking;
use std::ffi::OsStr;
use std::path::{Path, PathBuf};
use std::{fs, io};

pub fn fix_storage(
    config: &EnvConfig,
    storage_metadata: &mut StorageMetadata,
) -> Result<(), String> {
    let metadata = storage_metadata
        .metadata
        .as_mut()
        .ok_or(crate::INDEX_NOT_INITIALIZED_ERROR)?;

    let stored_files = get_indexed_files_from_directory(&config.storage_directory);

    metadata.retain(|file_metadata| {
        let does_file_with_id_exists = stored_files
            .iter()
            .any(|entry| entry.index == file_metadata.id);

        let does_id_have_tags = !file_metadata.tags.is_empty();

        does_file_with_id_exists && does_id_have_tags
    });

    Ok(())
}

pub fn init_storage(config: &EnvConfig) {
    fs::write(config.storage_directory.join("index.json"), "[]")
        .expect("Failed to initialize index.json");
}

pub fn delete(ids: &[u32], config: &EnvConfig) -> Result<Vec<u32>, String> {
    let mut removed_ids: Vec<u32> = vec![];

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

    let next_id = get_next_free_id(&config.storage_directory);
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

    let metadata = storage_metadata
        .metadata
        .as_mut()
        .expect(INDEX_NOT_INITIALIZED_ERROR);

    let mut next_free_id = get_indexed_files_from_directory(&config.storage_directory)
        .iter()
        .map(|entry| entry.index)
        .max()
        .unwrap_or(0)
        + 1;

    let mut already_present_in_storage_count = 0;
    let mut saved_files = 0;
    let mut skipped_images_count = 0;

    let new_posts_informations: Vec<PostInformations> = {
        let mut new_posts_informations_mut: Vec<PostInformations> = vec![];
        for post_informations in posts_informations {
            let filename_from_url =
                match utils::extract_filename_from_url(&post_informations.image_url) {
                    Ok(value) => value,
                    Err(err) => {
                        error!(
                            "{} is not a correct URL. {}",
                            post_informations.image_url, err
                        );
                        continue;
                    }
                };

            let does_file_already_exists_in_storage_metadata = metadata
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

        let mut new_image_metadata =
            FileMetadata::from_url(next_free_id, &post_informations.image_url);

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

        prompts::ask_for_additional_tags()
            .into_iter()
            .for_each(|e| new_image_metadata.tags.push(e));

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

        new_image_metadata.permalink = Some(post_informations.permalink.to_string());
        new_image_metadata.tags.push(format!(
            "{}x{}",
            resized_image.width(),
            resized_image.height()
        ));

        buffer.push((resized_image, new_image_metadata));

        if buffer.len() == 3 {
            persist_buffer(&mut buffer, config, storage_metadata);
        }

        saved_files += 1;
        next_free_id += 1;
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

pub fn organise(config: &EnvConfig) -> Vec<(u32, u32)> {
    let ordered_wallpapers = get_indexed_files_from_directory_in_order(&config.storage_directory);

    println!("{:#?}", ordered_wallpapers);

    let mut missing_numbers: Vec<u32> = vec![];

    let mut last_number = 0;

    for entry in ordered_wallpapers.iter() {
        if last_number == entry.index - 1 {
            last_number = entry.index;
            continue;
        }

        let numbers_gap = entry.index - last_number;

        for i in 1..numbers_gap {
            missing_numbers.push(i + last_number);
        }

        last_number = entry.index;
    }

    let mut moved_files = vec![];

    for (index, entry) in missing_numbers.iter().enumerate() {
        match ordered_wallpapers.get(ordered_wallpapers.len() - index - 1) {
            None => {
                println!("{:?}", ordered_wallpapers);
                println!(
                    "Couldn't get value with index {}",
                    ordered_wallpapers.len() - index - 1
                );
                break;
            }
            Some(value) => {
                fs::rename(
                    config.storage_directory.join(value.to_path()),
                    config
                        .storage_directory
                        .join(SimpleFile::new(*entry, value.format).to_path()),
                )
                .expect("Couldn't rename file");

                moved_files.push((value.index, *entry));
            }
        };
    }

    moved_files
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

fn get_file_id(file: &DirEntry) -> Option<u32> {
    let file_path = file.path();

    let file_stem = match file_path.file_stem() {
        None => return None,
        Some(value) => value,
    };

    let file_stem = match file_stem.to_str() {
        None => return None,
        Some(value) => value,
    };

    match file_stem.parse::<u32>() {
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

        match file_name_prefix.unwrap().parse::<u32>() {
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

fn get_next_free_id(path: &PathBuf) -> u32 {
    let current_files = get_indexed_files_from_directory_in_order(path);

    let mut new_file_index = current_files.len() + 1;

    for (index, entry) in current_files.iter().enumerate() {
        if (index as u32) != entry.index - 1 {
            new_file_index = index + 1;
            break;
        }
    }

    new_file_index as u32
}

fn persist_buffer(
    buffer: &mut Vec<(DynamicImage, FileMetadata)>,
    config: &EnvConfig,
    storage_metadata: &mut StorageMetadata,
) {
    println!("Persisting buffer");
    for (image, new_metadata) in buffer.drain(..) {
        let image_format = image::guess_format(image.as_bytes()).unwrap_or(ImageFormat::Jpeg);
        let absolute_file_path = config.storage_directory.join(format!(
            "{}.{}",
            new_metadata.id,
            image_format.extensions_str()[0]
        ));

        //TODO: Remove unwraping after https://trello.com/c/MJlIAvnG/4-storagemetadata
        storage_metadata
            .metadata
            .as_mut()
            .unwrap()
            .push(new_metadata);
        image.save(absolute_file_path).unwrap();
    }

    storage_metadata.persist();
}
