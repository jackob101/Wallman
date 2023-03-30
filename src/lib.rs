extern crate core;

use std::{env, fs, io};
use std::ffi::OsStr;
use std::io::{BufRead, Write};
use std::path::PathBuf;

use log::info;
use reqwest::blocking;

pub fn download(url: &str) {
    let wallpapers_directory = get_wallpaper_directory();

    info!("Downloading from url: {}", url);

    let file_from_url = blocking::get(url).expect("Unexpected error during file download").bytes().unwrap();

    let current_files = get_ordered_files_from_directory(&wallpapers_directory);

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


pub fn delete(id_to_delete: u32) {
    let wallpaper_directory = get_wallpaper_directory();

    info!("Trying to delete file with ID: {}", id_to_delete);

    let files_iterator = match fs::read_dir(&wallpaper_directory) {
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
                let absolute_file_path = wallpaper_directory.join(file_path);
                println!("Are you sure you want to delete file under path: {}", &absolute_file_path.to_str().expect("Couldn't parse path into String"));
                loop {
                    print!("Please confirm [Y/N]: ");
                    io::stdout().flush();
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

pub fn organize() {
    let wallpaper_directory = get_wallpaper_directory();

    let ordered_wallpapers = get_ordered_files_from_directory(&wallpaper_directory);

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

        if ordered_wallpapers.len() as u32 <= *entry {
            break;
        }

        match ordered_wallpapers.get(ordered_wallpapers.len() - index -1) {
            None => {
                println!("{:?}", ordered_wallpapers);
                println!("Couldn't get value with index {}", ordered_wallpapers.len() - index -1);
                break;
            }
            Some(value) => {
                println!("{}", value);
                fs::rename(wallpaper_directory.join(format!("{}.{}", value, "png")),
                           wallpaper_directory.join(format!("{}.{}", entry, "png")))
                    .expect("Couldn't rename file");
            }
        }
    }

    println!("Finished!");
}

fn get_wallpaper_directory() -> PathBuf {
    match env::var("WALLMAN_LOCALIZATION") {
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
    }
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
