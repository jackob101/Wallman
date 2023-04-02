extern crate core;

pub mod env_config;
pub mod tag;

use std::{env, fs, io};
use std::ffi::OsStr;
use std::io::{BufRead, Write};
use std::path::PathBuf;

use log::{debug, info};
use reqwest::{blocking, get};
use simple_log::file;
use crate::env_config::EnvConfig;
use crate::tag::MetaData;

pub fn download(url: &str, config: &EnvConfig) {
    info!("Downloading from url: {}", url);

    let file_from_url = blocking::get(url).expect("Unexpected error during file download").bytes().unwrap();

    let current_files = get_ordered_files_from_directory(&config.storage_directory);

    let mut new_file_index = current_files.len() + 1;

    for (index, entry) in current_files.iter().enumerate() {
        if (index as u32) != *entry - 1 {
            new_file_index = index + 1;
            break;
        }
    }

    let full_file_path = &config.storage_directory.join(format!("{}.{}", new_file_index, "png"));

    let image_from_request = image::load_from_memory(&file_from_url).unwrap();
    image_from_request.save(full_file_path).unwrap();
}


pub fn delete(id_to_delete: u32, config: &EnvConfig) {
    info!("Trying to delete file with ID: {}", id_to_delete);

    let files_iterator = match fs::read_dir(&config.storage_directory) {
        Ok(iterator) => iterator,
        Err(_) => panic!("Couldn't create iterator over wallpapers directory")
    };

    for file_result in files_iterator {
        let file = file_result.unwrap();
        let file_path = file.path();

        if file_path.is_dir() {
            continue;
        }

        if let Some(current_file_id) = file_path.file_stem() {
            let current_file_id = current_file_id.to_str()
                .expect("Couldn't parse file name into &str")
                .parse::<u32>()
                .expect("Couldn't parse file name into u32");

            if current_file_id == id_to_delete {
                let absolute_file_path = config.storage_directory.join(file_path);
                println!("Are you sure you want to delete file under path: {}", &absolute_file_path.to_str().expect("Couldn't parse path into String"));
                loop {
                    print!("Please confirm [Y/N]: ");
                    io::stdout().flush().expect("Failed to flush");
                    let mut input = String::new();
                    io::stdin().lock().read_line(&mut input).expect("Unexpected error during reading user input");
                    input = input.trim().to_string();

                    if input == "y" || input == "Y" {
                        println!("Removing file: {}", &absolute_file_path.to_str().expect("Couldn't parse path into String"));
                        if absolute_file_path.is_dir() {
                            panic!("COULDN'T REMOVE FILE BECAUSE IT WAS A DIRECTORY");
                        }
                        fs::remove_file(absolute_file_path).expect("Couldn't delete file");
                        break;
                    } else if input == "N" || input == "n" {
                        println!("Canceling");
                        break;
                    }
                    println!();
                }
                return;
            }
        }
    }

    println!("Passed ID wasn't found")
}

pub fn organize(config: &EnvConfig) {
    let ordered_wallpapers = get_ordered_files_from_directory(&config.storage_directory);

    let mut missing_numbers: Vec<u32> = vec![];

    let mut last_number = 0;

    for entry in ordered_wallpapers.iter() {
        if last_number == *entry - 1 {
            last_number = *entry;
            continue;
        }

        let numbers_gap = *entry - last_number;

        for i in 1..numbers_gap {
            missing_numbers.push(i + last_number);
        }

        last_number = *entry;
    }

    for (index, entry) in missing_numbers.iter().enumerate() {
        match ordered_wallpapers.get(ordered_wallpapers.len() - index - 1) {
            None => {
                println!("{:?}", ordered_wallpapers);
                println!("Couldn't get value with index {}", ordered_wallpapers.len() - index - 1);
                break;
            }
            Some(value) => {
                println!("{}", value);
                fs::rename(config.storage_directory.join(format!("{}.{}", value, "png")),
                           config.storage_directory.join(format!("{}.{}", entry, "png")))
                    .expect("Couldn't rename file");
            }
        }
    }
}

pub fn init_storage(config: &EnvConfig){
    fs::write(config.storage_directory.join("index.csv"), "").expect("Failed to initialize index.csv");
}

pub fn tag_add(file_name: &String, tags: &String, config: &EnvConfig) {
    let index_path = config.storage_directory.join("index.csv");

    let mut reader = csv::ReaderBuilder::new()
        .has_headers(false)
        .flexible(true)
        .from_path(&index_path)
        .expect("Couldn't open index.csv. Check if the file index.csv exists in storage directory. If it doesn't exists run 'tag init' or create it manually");

    let mut files_meta_data = reader.deserialize()
        .into_iter()
        .map(|entry| entry.expect("Couldn't parse"))
        .collect::<Vec<MetaData>>();

    let mut does_file_already_contains_metadata = false;

    for file_metadata in files_meta_data.iter_mut() {
        if file_metadata.file_name.eq(file_name) {
            file_metadata.add_tag(tags);
            does_file_already_contains_metadata = true;
            break;
        }
    }

    if !does_file_already_contains_metadata {
        files_meta_data.push(MetaData::new(file_name.to_string(), MetaData::parse_tags(tags.to_owned())));
    }

    let mut writer = csv::WriterBuilder::new()
        .flexible(true)
        .has_headers(false)
        .from_path(&index_path)
        .expect("Failed to create csv writer");

    for file_meta_data in files_meta_data.iter() {
        writer.serialize(file_meta_data).expect("Couldn't serialize record");
    }

    writer.flush().expect("Couldn't flush writer");
}


fn get_ordered_files_from_directory(path: &PathBuf) -> Vec<u32> {
    let mut current_files: Vec<u32> = vec![];

    for entry in fs::read_dir(&path).unwrap() {
        let entry = entry.unwrap();
        let path = entry.path();
        if path.is_file() {
            let file_name = path.file_stem().unwrap_or_else(|| OsStr::new("0"));
            current_files.push(match file_name.to_str() {
                None => 0,
                Some(val) => val.parse::<u32>().unwrap_or(0)
            })
        }
    };

    current_files.sort();

    current_files
}
