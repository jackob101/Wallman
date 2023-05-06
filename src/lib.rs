extern crate core;

pub mod env_config;
pub mod metadata;
pub mod simple_file;
pub mod storage;

use image::ImageFormat;
use std::ffi::OsStr;

use std::fs;
use std::path::PathBuf;

use crate::env_config::EnvConfig;
use crate::metadata::StorageMetadata;
use crate::simple_file::SimpleFile;


pub fn init_storage(config: &EnvConfig) {
    fs::write(config.storage_directory.join("index.json"), "")
        .expect("Failed to initialize index.json");
}

pub fn fix_storage(config: &EnvConfig, storage_metadata: &mut StorageMetadata) -> Result<(), String>{

    let metadata = storage_metadata
        .metadata
        .as_mut()
        .ok_or(metadata::INDEX_NOT_INITIALIZED_ERROR)?;

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
