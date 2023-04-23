use crate::env_config::EnvConfig;

use serde::{Deserialize, Serialize};
use std::fs::{DirEntry, File};
use std::io::{BufReader, Write};
use std::path::PathBuf;
use std::{fs, io};

pub const INDEX: &str = "index.json";

#[derive(Serialize, Deserialize, Debug)]
pub struct FileMetadata {
    pub id: u32,
    #[serde(skip_serializing_if = "Vec::is_empty", default)]
    pub tags: Vec<String>,
}

impl FileMetadata {
    pub fn new(index: u32, tags: Vec<String>) -> FileMetadata {
        FileMetadata { id: index, tags }
    }

    pub fn add_tag(&mut self, new_tag: &String) -> Result<(), String> {
        if self.tags.contains(new_tag) {
            return Err("Tag is already assigned for specified ID".to_string());
        };
        self.tags.push(new_tag.to_owned());
        Ok(())
    }

    pub fn remove_tag(&mut self, tag_name: &String) -> Result<(), String> {
        let position_option = self.tags.iter().position(|entry| entry.eq(tag_name));

        match position_option {
            None => Err(format!(
                "Tag {} is not assigned to ID {}",
                tag_name, self.id
            )),
            Some(value) => {
                self.tags.remove(value);
                Ok(())
            }
        }
    }

    pub fn contains_tags(&self, tags: &Vec<String>) -> bool {
        for tag in tags {
            if !self.tags.contains(tag) {
                return false;
            }
        }
        true
    }

    pub fn move_id(&mut self, to: u32) {
        self.id = to;
    }
}

pub struct StorageMetadata {
    path: PathBuf,
    pub metadata: Vec<FileMetadata>,
}

impl StorageMetadata {
    pub fn new(config: &EnvConfig) -> StorageMetadata {
        let path_to_index_file = config.storage_directory.join(INDEX);

        let reader = match File::open(&path_to_index_file) {
            Ok(reader) => reader,
            Err(_) => todo!(),
        };

        let metadata =
            serde_json::from_reader(BufReader::new(reader)).expect("Failed to parse json");

        StorageMetadata {
            path: path_to_index_file,
            metadata,
        }
    }

    pub fn add_tag_to_id(
        &mut self,
        id: u32,
        tags: Vec<String>,
        config: &EnvConfig,
    ) -> Result<(), String> {
        let does_file_exists = fs::read_dir(&config.storage_directory)
            .expect("Couldn't read storage directory")
            .any(|entry| StorageMetadata::name_with_id_predicate(id, entry));

        if !does_file_exists {
            return Err("Can't add tags to file that doesn't exists!".to_string());
        }

        let metadata_for_index_option = self.metadata.iter_mut().find(|entry| entry.id.eq(&id));

        match metadata_for_index_option {
            None => {
                self.metadata.push(FileMetadata::new(id, tags));
                Ok(())
            }
            Some(metadata) => {
                tags.iter()
                    .for_each(|new_tag| metadata.add_tag(new_tag).expect("Couldn't add new tag"));
                Ok(())
            }
        }
    }

    pub fn remove_tag_from_id(&mut self, id: u32, tags: Vec<String>) -> Result<(), String> {
        let metadata_for_index_option = self.metadata.iter_mut().find(|entry| entry.id.eq(&id));

        match metadata_for_index_option {
            None => Err("File with specified ID doesn't exists".to_string()),
            Some(metadata) => {
                for tag in tags {
                    metadata.remove_tag(&tag)?
                }
                Ok(())
            }
        }
    }

    pub fn remove_all_tags_from_id(&mut self, ids: &Vec<u32>) -> Result<(), String> {
        for id in ids {
            let index_in_vector = self.metadata.iter().position(|entry| entry.id == *id);

            match index_in_vector {
                None => return Err(format!("ID: {} not found in {}", id, INDEX)),
                Some(value) => {
                    self.metadata.remove(value);
                }
            };
        }
        Ok(())
    }

    pub fn move_index(&mut self, from: u32, to: u32) -> Result<(), String> {
        let found_metadata_about_file = self.metadata.iter_mut().find(|entry| entry.id == from);

        match found_metadata_about_file {
            None => Err("Index not found".to_string()),
            Some(value) => {
                value.move_id(to);
                Ok(())
            }
        }
    }

    pub fn query(&self, tags: Vec<String>) -> Vec<&FileMetadata> {
        if tags.is_empty() {
            return self.metadata.iter().collect();
        }

        let mut matching_elements: Vec<&FileMetadata> = vec![];

        for entry in &self.metadata {
            if entry.contains_tags(&tags) {
                matching_elements.push(entry);
            }
        }

        matching_elements
    }

    pub fn persist(&self) {
        println!("persisting {}", INDEX);

        let file = fs::OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open(&self.path)
            .expect("Failed to open/create file");
        serde_json::to_writer(&file, &self.metadata).expect("Failed to write");
    }

    fn name_with_id_predicate(index: u32, entry: io::Result<DirEntry>) -> bool {
        match entry {
            Ok(dir_entry) => {
                let file_id = dir_entry
                    .path()
                    .file_stem()
                    .expect("Missing file stem")
                    .to_str()
                    .expect("Couldn't parse file name into &str")
                    .parse::<u32>();

                match file_id {
                    Ok(value) => value == index,
                    Err(_) => false,
                }
            }
            Err(_) => false,
        }
    }
}
