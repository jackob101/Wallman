extern crate core;

use std::ffi::OsStr;
use std::{env, fs};
use std::env::VarError;
use std::path::{Path, PathBuf};
use log::info;
use reqwest::blocking;

pub fn download(url: &str) {
    let wallpapers_directory = match env::var("WALLMAN_LOCALIZATION") {
        Ok(value) => {
            info!("Using directory from env variable for storage: {}", value);
            let directory = PathBuf::from(value);
            if !directory.is_dir() {
                panic!("Provide path is not an directory")
            }

            directory
        }
        Err(_) => {
            info!("Using default directory for storage");
            home::home_dir().unwrap().join("Wallpapers")
        }
    };

    info!("Downloading from url: {}", url);

    let file_from_url = blocking::get(url).expect("Unexpected error during file download").bytes().unwrap();

    let mut current_files: Vec<u32> = vec![];

    for entry in fs::read_dir(&wallpapers_directory).unwrap() {
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

    let mut new_file_index = current_files.len() + 1;

    for (index, entry) in current_files.iter().enumerate() {
        if (index as u32) != *entry - 1 {
            new_file_index = index + 1;
            break;
        }
    }


    let full_file_path = &wallpapers_directory.join(format!("{}.{}", new_file_index, "png"));

    let image_from_request = image::load_from_memory(&file_from_url).unwrap();
    image_from_request.save(full_file_path).unwrap();
}

pub fn print_help_menu(){

    println!("Available operations: ");
    println!("download [URL]");
    println!("organize");

}