use std::{env, fs};
use std::ffi::OsStr;
use std::fs::File;
use std::io::{Cursor, Read, Write};
use image::{ColorType, DynamicImage, ImageBuffer, save_buffer};
use image::io::Reader;

use reqwest::{blocking, Url};


fn main() -> Result<(), String> {
    let args: Vec<String> = env::args().collect();
    let wallpaper_directory = home::home_dir().unwrap().join("Wallpapers");

    let url = match Url::parse(&args[1]) {
        Ok(url) => url,
        Err(_) => panic!("Podany parametr nie jest URL")
    };


    let image_from_request = blocking::get(url).expect("Bład przy pobieraniu z linku").bytes().unwrap();


    let mut old_files: Vec<u32> = vec![];

    for entry in fs::read_dir(&wallpaper_directory).unwrap() {
        let entry = entry.unwrap();
        let path = entry.path();
        if path.is_file() {
            let file_name = path.file_stem().unwrap_or_else(|| OsStr::new("0"));
            old_files.push(match file_name.to_str() {
                None => 0,
                Some(val) => val.parse::<u32>().unwrap_or(0)
            })
        }
    };

    old_files.sort();


    let mut new_file_index = old_files.len() + 1;

    for (index, entry) in old_files.iter().enumerate() {
        if (index as u32) != *entry - 1 {
            new_file_index = index + 1;
            break;
        }
    }


    let full_file_path = &wallpaper_directory.join(format!("{}.{}", new_file_index, "png"));

    let image_from_request = image::load_from_memory(&image_from_request).unwrap();
    image_from_request.save(full_file_path).unwrap();

    Ok(())
}
