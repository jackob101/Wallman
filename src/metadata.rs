use crate::env_config::EnvConfig;
use clap::builder::Str;
use clap::parser::ValuesRef;
use log::Metadata;
use serde::{Deserialize, Serialize};
use std::fs::DirEntry;
use std::path::{Iter, PathBuf};
use std::{fs, io};

#[derive(Serialize, Deserialize, Debug)]
pub struct FileMetadata {
    pub index: u32,
    #[serde(skip_serializing_if = "Vec::is_empty", default)]
    pub tags: Vec<String>,
}

impl FileMetadata {
    pub fn new(index: u32, tags: Vec<String>) -> FileMetadata {
        FileMetadata { index, tags }
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
                tag_name, self.index
            )),
            Some(value) => {
                self.tags.remove(value);
                Ok(())
            }
        }
    }

    pub fn contains_tags(&self, tags: &Vec<String>) -> bool {
        for tag in tags {
            if !self.tags.contains(&tag) {
                return false;
            }
        }
        true
    }

    pub fn move_id(&mut self, to: u32) {
        self.index = to;
    }
}

pub struct StorageMetadata {
    path: PathBuf,
    pub metadata: Vec<FileMetadata>,
}

impl StorageMetadata {
    pub fn new(config: &EnvConfig) -> StorageMetadata {
        let path_to_index_file = config.storage_directory.join("index.csv");

        let mut reader = csv::ReaderBuilder::new()
            .has_headers(false)
            .flexible(true)
            .from_path(&path_to_index_file)
            .expect("Couldn't open index.csv. Check if the file index.csv exists in storage directory. If it doesn't exists run 'tag init' or create it manually");

        let metadata = reader
            .deserialize()
            .into_iter()
            .map(|entry| entry.expect("Couldn't parse"))
            .collect::<Vec<FileMetadata>>();

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

        let metadata_for_index_option = self.metadata.iter_mut().find(|entry| entry.index.eq(&id));

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
        let metadata_for_index_option = self.metadata.iter_mut().find(|entry| entry.index.eq(&id));

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

    pub fn remove_all_tags_from_id(&mut self, id: u32) -> Result<(), String> {
        let index_in_vector = self.metadata.iter().position(|entry| entry.index == id);

        match index_in_vector {
            None => Err(format!("ID: {} not found in index.csv", id)),
            Some(value) => {
                self.metadata.remove(value);
                Ok(())
            }
        }
    }

    pub fn move_index(&mut self, from: u32, to: u32) -> Result<(), String> {
        let found_metadata_about_file = self.metadata.iter_mut().find(|entry| entry.index == from);

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
        println!("persisting index.csv");

        let mut writer = csv::WriterBuilder::new()
            .flexible(true)
            .has_headers(false)
            .from_path(&self.path)
            .expect("Failed to create csv writer");

        for file_meta_data in self.metadata.iter() {
            if file_meta_data.tags.is_empty() {
                continue;
            }
            writer
                .serialize(file_meta_data)
                .expect("Couldn't serialize record");
        }

        writer.flush().expect("Couldn't flush writer");
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
