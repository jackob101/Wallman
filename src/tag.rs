use std::error::Error;
use std::ffi::OsStr;
use std::{fs, io};
use std::fs::DirEntry;
use std::num::ParseIntError;
use std::ops::Index;
use std::os::unix::prelude::DirEntryExt;
use std::path::PathBuf;
use std::process::id;
use std::ptr::eq;
use csv::StringRecord;
use home::home_dir;
use serde::{Deserialize, Serialize};
use crate::env_config::EnvConfig;

#[derive(Serialize, Deserialize, Debug)]
pub struct MetaData {
    pub index: u32,
    pub tags: Vec<String>,
}

impl MetaData {
    pub fn new(index: u32, tags: Vec<String>) -> MetaData {
        MetaData {
            index,
            tags,
        }
    }

    pub fn parse_tags(tags: String) -> Vec<String> {
        tags.split(';')
            .map(|s| s.to_owned())
            .collect::<Vec<String>>()
    }

    pub fn add_tag(&mut self, new_tag: &String) -> Result<(), String> {
        if self.tags.contains(new_tag) {
            return Err("Tag is already assigned for specified ID".to_string());
        };
        self.tags.push(new_tag.to_owned());
        Ok(())
    }

    pub fn remove_tag(&mut self, tag_name: &String) -> Result<(), String> {
        let old_size = self.tags.len();

        self.tags.retain(|entry| !entry.eq(tag_name));

        if old_size == self.tags.len() {
            println!("Same size of tags");
            return Err(format!("Tag {} doesn't exists for file {}", tag_name, self.index));
        }

        Ok(())
    }
}

pub struct IndexData {
    path: PathBuf,
    metadata: Vec<MetaData>,
}

impl IndexData {
    pub fn init(config: &EnvConfig) -> IndexData {
        let path_to_index_file = config.storage_directory.join("index.csv");

        let mut reader = csv::ReaderBuilder::new()
            .has_headers(false)
            .flexible(true)
            .from_path(&path_to_index_file)
            .expect("Couldn't open index.csv. Check if the file index.csv exists in storage directory. If it doesn't exists run 'tag init' or create it manually");

        let metadata = reader.deserialize()
            .into_iter()
            .map(|entry| entry.expect("Couldn't parse"))
            .collect::<Vec<MetaData>>();

        IndexData {
            path: path_to_index_file,
            metadata,
        }
    }

    pub fn add_tag(&mut self, index: u32, tags: &String, config: &EnvConfig) -> Result<(), String> {
        let equal_file_name_predicate = |entry: io::Result<DirEntry>| {
            match entry {
                Ok(dir_entry) => {
                    let file_id = dir_entry.path()
                        .file_stem()
                        .expect("Missing file stem")
                        .to_str()
                        .expect("Couldn't parse file name into &str")
                        .parse::<u32>();

                    match file_id {
                        Ok(value) => value == index,
                        Err(_) => false
                    }
                }
                Err(_) => false
            }
        };

        let does_file_exists = fs::read_dir(&config.storage_directory)
            .expect("Couldn't read storage directory")
            .any(equal_file_name_predicate);


        if !does_file_exists {
            return Err("Can't add tags to file that doesn't exists!".to_string());
        }

        let metadata_for_index_option = self.metadata.iter_mut()
            .find(|entry| entry.index.eq(&index));

        match metadata_for_index_option {
            None => {
                self.metadata.push(MetaData::new(index, MetaData::parse_tags(tags.to_owned())));
                Ok(())
            }
            Some(metadata) => metadata.add_tag(tags)
        }
    }

    pub fn remove_tag(&mut self, index: u32, tags: &String) -> Result<(), String> {
        let metadata_for_index_option = self.metadata.iter_mut()
            .find(|entry| entry.index.eq(&index));

        match metadata_for_index_option {
            None => Err("File with specified ID doesn't exists".to_string()),
            Some(metadata) => metadata.remove_tag(tags),
        }
    }
}

impl Drop for IndexData {
    fn drop(&mut self) {
        println!("Writing index.csv!");

        let mut writer = csv::WriterBuilder::new()
            .flexible(true)
            .has_headers(false)
            .from_path(&self.path)
            .expect("Failed to create csv writer");

        for file_meta_data in self.metadata.iter() {
            if file_meta_data.tags.is_empty() {
                continue;
            }
            writer.serialize(file_meta_data).expect("Couldn't serialize record");
        }

        writer.flush().expect("Couldn't flush writer");
    }
}