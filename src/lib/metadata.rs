use crate::env_config::EnvConfig;

use log::{debug, info};
use serde::{Deserialize, Serialize};
use std::fs::{DirEntry, File};
use std::io::{BufReader};
use std::path::PathBuf;

use std::borrow::ToOwned;
use std::{fs, io};

#[derive(Serialize, Deserialize, Debug)]
pub struct FileMetadata {
    pub id: u32,
    #[serde(skip_serializing_if = "Vec::is_empty", default)]
    pub tags: Vec<String>,
    pub url: Option<String>,
    pub url_filename: Option<String>,
    pub permalink: Option<String>,
}

impl FileMetadata {
    pub fn new(index: u32, tags: Vec<String>) -> FileMetadata {
        FileMetadata {
            id: index,
            tags,
            url: None,
            url_filename: None,
            permalink: None,
        }
    }

    pub fn from_url(index: u32, url: &String) -> FileMetadata {
        let question_mark_index = url
            .find("?")
            .expect("There are no preview url's without query params");

        let end_of_domain_index = url.find("it/").expect("Incorrect url");

        let url_filename = &url[end_of_domain_index + 3..question_mark_index];

        debug!(
            "{} {} {}",
            question_mark_index, end_of_domain_index, url_filename
        );

        FileMetadata {
            id: index,
            tags: vec![],
            url: Some(url.to_string()),
            url_filename: Some(url_filename.to_string()),
            permalink: None,
        }
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
    pub metadata: Option<Vec<FileMetadata>>,
}

impl StorageMetadata {
    pub fn new(config: &EnvConfig) -> StorageMetadata {
        let path_to_index_file = config.storage_directory.join(crate::INDEX);

        match File::open(&path_to_index_file) {
            Ok(reader) => {
                let metadata = serde_json::from_reader(BufReader::new(reader))
                    .expect("Failed to parse metadata");
                StorageMetadata {
                    path: path_to_index_file,
                    metadata: Some(metadata),
                }
            }
            Err(_) => StorageMetadata {
                path: path_to_index_file,
                metadata: None,
            },
        }
    }

    pub fn add_tag_to_id(
        &mut self,
        id: u32,
        tags: Vec<String>,
        config: &EnvConfig,
    ) -> Result<(), String> {
        let metadata = self
            .metadata
            .as_mut()
            .ok_or(crate::INDEX_NOT_INITIALIZED_ERROR)?;

        let does_file_exists = fs::read_dir(&config.storage_directory)
            .expect("Couldn't read storage directory")
            .any(|entry| StorageMetadata::name_with_id_predicate(id, entry));

        if !does_file_exists {
            return Err("Can't add tags to file that doesn't exists!".to_string());
        }

        let metadata_for_index_option = metadata.iter_mut().find(|entry| entry.id.eq(&id));

        match metadata_for_index_option {
            None => {
                metadata.push(FileMetadata::new(id, tags));
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
        let metadata = self
            .metadata
            .as_mut()
            .ok_or(crate::INDEX_NOT_INITIALIZED_ERROR)?;

        let metadata_for_index_option = metadata.iter_mut().find(|entry| entry.id.eq(&id));

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

    pub fn move_index(&mut self, from: u32, to: u32) -> Result<(), String> {
        let metadata = self
            .metadata
            .as_mut()
            .ok_or(crate::INDEX_NOT_INITIALIZED_ERROR)?;

        let found_metadata_about_file = metadata.iter_mut().find(|entry| entry.id == from);

        match found_metadata_about_file {
            None => Err("Index not found".to_string()),
            Some(value) => {
                value.move_id(to);
                Ok(())
            }
        }
    }

    pub fn query(&self, tags: Vec<String>) -> Result<Vec<&FileMetadata>, String> {
        let metadata = self
            .metadata
            .as_ref()
            .ok_or(crate::INDEX_NOT_INITIALIZED_ERROR)?;

        if tags.is_empty() {
            return Ok(metadata.iter().collect());
        }

        let mut matching_elements: Vec<&FileMetadata> = vec![];

        for entry in metadata {
            if entry.contains_tags(&tags) {
                matching_elements.push(entry);
            }
        }

        Ok(matching_elements)
    }

    pub fn persist(&self) {
        if self.metadata.is_none() {
            return;
        }

        info!("persisting {}", crate::INDEX);

        let file = fs::OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open(&self.path)
            .expect("Failed to open/create file");
        serde_json::to_writer(&file, &self.metadata).expect("Failed to write");
    }

    pub fn move_all_tags(&mut self, moved_files: &[(u32, u32)]) -> Result<(), String> {
        let metadata = self
            .metadata
            .as_mut()
            .ok_or(crate::INDEX_NOT_INITIALIZED_ERROR)?;

        for entry in metadata.iter_mut() {
            for moved_file in moved_files.iter() {
                if moved_file.0 == entry.id {
                    entry.move_id(moved_file.1);
                }
            }
        }
        Ok(())
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

pub fn delete(storage_metadata: &mut StorageMetadata, ids: &[u32]) -> Result<(), String> {
    let metadata = storage_metadata
        .metadata
        .as_mut()
        .ok_or(crate::INDEX_NOT_INITIALIZED_ERROR)?;

    metadata.retain(|entry| !ids.iter().any(|id| entry.id == *id));

    Ok(())
}
