use crate::env_config::EnvConfig;
use crate::metadata::{FileMetadata, StorageMetadata};
use crate::reddit::client::ClockedClient;
use crate::reddit::APP_USER_AGENT;
use crate::{reddit, utils, INDEX_NOT_INITIALIZED_ERROR};

use std::fs::DirEntry;
use std::io::{BufRead, Write};

use crate::simple_file::SimpleFile;
use image::ImageFormat;
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

    let stored_files = get_files_from_directory(&config.storage_directory);

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
    posts_informations: &[reddit::structs::PostInformations],
    config: &EnvConfig,
    storage_metadata: &mut StorageMetadata,
) -> Result<(), String> {
    println!("Starting bulk download");

    let mut next_free_id = get_last_id(&config.storage_directory) + 1;

    let request_client = reqwest::blocking::Client::builder()
        .user_agent(reddit::APP_USER_AGENT)
        .build()
        .expect("Failed to create request client");

    let mut new_files_metadata: Vec<FileMetadata> = vec![];

    let metadata = storage_metadata
        .metadata
        .as_mut()
        .expect(INDEX_NOT_INITIALIZED_ERROR);

    for post_informations in posts_informations {
        let url_filename = match utils::extract_filename_from_url(&post_informations.image_url) {
            Ok(value) => value,
            Err(err) => {
                error!(
                    "{} is not a correct URL. {}",
                    post_informations.image_url, err
                );
                continue;
            }
        };

        let mut new_file_metadata =
            FileMetadata::from_url(next_free_id, &post_informations.image_url);

        let does_file_already_exists = metadata
            .iter()
            .filter_map(|old_file| old_file.url_filename.as_ref())
            .any(|old_filename| old_filename.eq(url_filename));

        if does_file_already_exists {
            println!(
                "File from URL: {} already exists in storage",
                &post_informations.image_url
            );
            continue;
        }

        println!("{:?}", post_informations.image_url);

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

        let image_format = match image::guess_format(&bytes) {
            Ok(value) => value,
            Err(err) => {
                error!("Failed to guess image format, using default. {}", err);
                ImageFormat::Jpeg
            }
        };

        let absolute_file_path =
            config
                .storage_directory
                .join(utils::format_filename_and_extension(
                    &next_free_id.to_string(),
                    image_format,
                ));

        let image = match image::load_from_memory(&bytes) {
            Ok(value) => value,
            Err(err) => {
                println!("Failed to get image {}", err);
                continue;
            }
        };

        utils::print(&image);
        println!("Additional tags: ");
        let mut additional_tags: String = "".to_string();
        std::io::stdin()
            .lock()
            .read_line(&mut additional_tags)
            .expect("TODO Handle error during input");

        additional_tags
            .split(',')
            .map(|e| e.trim().to_owned())
            .for_each(|e| new_file_metadata.tags.push(e));

        image.save(absolute_file_path).unwrap();

        new_file_metadata
            .tags
            .push(format!("{}x{}", image.width(), image.height()));

        new_file_metadata.permalink = Some(post_informations.permalink.to_string());
        new_files_metadata.push(new_file_metadata);

        next_free_id += 1;
    }

    for new_file_metdata in new_files_metadata {
        metadata.push(new_file_metdata);
    }

    Ok(())
}

pub fn organise(config: &EnvConfig) -> Vec<(u32, u32)> {
    let ordered_wallpapers = get_ordered_files_from_directory(&config.storage_directory);

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

fn get_ordered_files_from_directory(path: &PathBuf) -> Vec<SimpleFile> {
    let mut current_files: Vec<SimpleFile> = get_files_from_directory(path);

    current_files.sort_by(|x, x1| x.index.cmp(&x1.index));

    current_files
}

fn get_files_from_directory(path: &PathBuf) -> Vec<SimpleFile> {
    let mut current_files: Vec<SimpleFile> = vec![];

    for entry in fs::read_dir(&path).unwrap() {
        let entry = entry.unwrap();
        let path = entry.path();
        if path.is_file() {
            let file_name = path.file_stem().unwrap_or_else(|| OsStr::new("0"));

            // TODO: This is ugly
            if file_name.eq(OsStr::new("index"))
                || file_name
                    .to_str()
                    .expect("Failed to get str")
                    .starts_with('.')
            {
                continue;
            }

            current_files.push(match file_name.to_str() {
                None => continue,
                Some(val) => {
                    let index = val.parse::<u32>().unwrap_or(0);
                    let format =
                        ImageFormat::from_extension(path.extension().expect("Missing format"))
                            .expect("");
                    SimpleFile::new(index, format)
                }
            })
        }
    }

    current_files
}

fn get_last_id(path: &PathBuf) -> u32 {
    let files_inside_directory = get_files_from_directory(path);

    files_inside_directory
        .iter()
        .map(|entry| entry.index)
        .max()
        .unwrap_or(0)
}

fn get_next_free_id(path: &PathBuf) -> u32 {
    let current_files = get_ordered_files_from_directory(path);

    let mut new_file_index = current_files.len() + 1;

    for (index, entry) in current_files.iter().enumerate() {
        if (index as u32) != entry.index - 1 {
            new_file_index = index + 1;
            break;
        }
    }

    new_file_index as u32
}
