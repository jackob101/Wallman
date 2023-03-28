#[macro_use]
extern crate simple_log;

use std::{env, fs};
use std::ffi::OsStr;
use std::fs::File;
use std::io::{Cursor, Read, Write};
use image::{ColorType, DynamicImage, ImageBuffer, save_buffer};
use image::io::Reader;
use log::__log_key;

use reqwest::{blocking, Url};
use simple_log::LogConfigBuilder;
use wallman_lib::{download, print_help_menu};


fn main() -> Result<(), String> {
    setup_logger()?;

    let args: Vec<String> = env::args().collect();

    let operation: &str = match args.get(1) {
        None => {
            print_help_menu();
            return Err("Please pass operation".to_string());
        }
        Some(value) => value,
    };

    match operation {
        "help" => {
            print_help_menu();
        }
        "download" => {
            match args.get(2) {
                None => return Err("'download' operation required url parameter".to_string()),
                Some(url) => download(url),
            }
        }
        _ => {
            print_help_menu();
            return Err("Unknown operation".to_string());
        }
    }

    Ok(())
}

fn setup_logger() -> Result<(), String> {
    let config = LogConfigBuilder::builder()
        .output_console()
        .build();

    simple_log::new(config)?;
    info!("Logger configured");

    Ok(())
}
