extern crate core;

pub mod env_config;
pub mod simple_file;
pub mod tag;

use image::ImageFormat;
use std::ffi::OsStr;
use std::io::{BufRead, Write};
use std::path::PathBuf;
use std::{fs, io};

use crate::env_config::EnvConfig;
use crate::simple_file::SimpleFile;
use crate::tag::{FileMetadata, StorageMetadata};
use log::{debug, info, Metadata};
use reqwest::blocking;
use simple_log::file;

pub fn download(url: &str, config: &EnvConfig) -> SimpleFile {
    info!("Downloading from url: {}", url);

    let file_from_url = blocking::get(url)
        .expect("Unexpected error during file download")
        .bytes()
        .unwrap();

    let current_files = get_ordered_files_from_directory(&config.storage_directory);

    let mut new_file_index = current_files.len() + 1;

    for (index, entry) in current_files.iter().enumerate() {
        if (index as u32) != entry.index - 1 {
            new_file_index = index + 1;
            break;
        }
    }

    let image_format =
        image::guess_format(&file_from_url).expect("Couldn't determine default file extension");

    let image_file = SimpleFile::new(new_file_index as u32, image_format);

    let absolute_file_path = &config.storage_directory.join(image_file.to_path());

    image::load_from_memory(&file_from_url)
        .unwrap()
        .save(absolute_file_path)
        .unwrap();

    image_file
}

pub fn delete(id_to_delete: u32, config: &EnvConfig) -> Result<bool, String> {
    info!("Trying to delete file with ID: {}", id_to_delete);

    let files_iterator = match fs::read_dir(&config.storage_directory) {
        Ok(iterator) => iterator,
        Err(_) => panic!("Couldn't create iterator over wallpapers directory"),
    };

    for dir_entry in files_iterator {
        let file_path = dir_entry.unwrap().path();

        if file_path.is_dir() {
            continue;
        }

        if let Some(current_file_id) = file_path.file_stem() {
            let parsed_id = current_file_id
                .to_str()
                .expect("Couldn't parse file name into &str")
                .parse::<u32>();

            let current_file_id = match parsed_id {
                Ok(value) => value,
                Err(_) => continue,
            };

            if current_file_id != id_to_delete {
                continue;
            }

            let absolute_file_path = config.storage_directory.join(file_path);

            println!(
                "Are you sure you want to delete file under path: {}",
                &absolute_file_path
                    .to_str()
                    .expect("Couldn't parse path into String")
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
                    println!(
                        "Removing file: {}",
                        &absolute_file_path
                            .to_str()
                            .expect("Couldn't parse path into String")
                    );
                    fs::remove_file(absolute_file_path).expect("Couldn't delete file");
                    return Ok(true);
                } else if input == "N" || input == "n" {
                    println!("Canceling");
                    return Ok(false);
                }
                println!();
            }
        }
    }

    Err("File not found".to_string())
}

pub fn organize(config: &EnvConfig, storage_metadata: &mut StorageMetadata) {
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
                storage_metadata.move_index(value.index, *entry);

                fs::rename(
                    config.storage_directory.join(value.to_path()),
                    config
                        .storage_directory
                        .join(SimpleFile::new(*entry, value.format).to_path()),
                )
                .expect("Couldn't rename file");
            }
        }
    }
}

pub fn init_storage(config: &EnvConfig) {
    fs::write(config.storage_directory.join("index.csv"), "")
        .expect("Failed to initialize index.csv");
}

pub fn fix_storage(config: &EnvConfig, storage_metadata: &mut StorageMetadata) {
    let stored_files = get_files_from_directory(&config.storage_directory);

    storage_metadata.metadata.retain(|file_metadata| {
        let does_file_with_id_exists = stored_files
            .iter()
            .any(|entry| entry.index == file_metadata.index);

        let does_id_have_tags = !file_metadata.tags.is_empty();

        does_file_with_id_exists && does_id_have_tags
    });
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

            if file_name.eq(OsStr::new("index")) {
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
