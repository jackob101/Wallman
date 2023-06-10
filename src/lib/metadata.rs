use crate::env_config::EnvConfig;

use log::{debug, info};
use serde::{Deserialize, Serialize};
use std::fs::{DirEntry, File};
use std::io::BufReader;
use std::path::PathBuf;
use uuid::Uuid;

use std::borrow::ToOwned;
use std::{fs, io};

#[derive(Serialize, Deserialize, Debug)]
pub struct FileMetadata {
    pub id: Uuid,
    #[serde(skip_serializing_if = "Vec::is_empty", default)]
    pub tags: Vec<String>,
    pub url: Option<String>,
    pub url_filename: Option<String>,
    pub permalink: Option<String>,
    pub resolution: Option<(u32, u32)>,
}

impl FileMetadata {
    pub fn new(index: Uuid, tags: Vec<String>) -> FileMetadata {
        FileMetadata {
            id: index,
            tags,
            url: None,
            url_filename: None,
            permalink: None,
            resolution: None,
        }
    }

    pub fn from_url(index: Uuid, url: &String) -> FileMetadata {
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
            resolution: None,
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
}

pub struct StorageMetadata {
    path: PathBuf,
    pub metadata: Vec<FileMetadata>,
}

impl StorageMetadata {
    pub fn new(config: &EnvConfig) -> Option<StorageMetadata> {
        let path_to_index_file = config.storage_directory.join(crate::INDEX);

        match File::open(&path_to_index_file) {
            Ok(reader) => {
                let metadata = serde_json::from_reader(BufReader::new(reader))
                    .expect("Failed to parse metadata");
                Some(StorageMetadata {
                    path: path_to_index_file,
                    metadata,
                })
            }
            Err(_) => None,
        }
    }

    pub fn add_tag_to_id(
        &mut self,
        id: Uuid,
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

    pub fn remove_tag_from_id(&mut self, id: Uuid, tags: Vec<String>) -> Result<(), String> {
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

    pub fn query(&self, tags: Vec<String>) -> Result<Vec<&FileMetadata>, String> {
        if tags.is_empty() {
            return Ok(self.metadata.iter().collect());
        }

        let mut matching_elements: Vec<&FileMetadata> = vec![];

        for entry in &self.metadata {
            if entry.contains_tags(&tags) {
                matching_elements.push(&entry);
            }
        }

        Ok(matching_elements)
    }

    pub fn persist(&self) {
        info!("persisting {}", crate::INDEX);

        let file = fs::OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open(&self.path)
            .expect("Failed to open/create file");
        serde_json::to_writer(&file, &self.metadata).expect("Failed to write");
    }

    fn name_with_id_predicate(index: Uuid, entry: io::Result<DirEntry>) -> bool {
        match entry {
            Ok(dir_entry) => {
                let file_id = dir_entry
                    .path()
                    .file_stem()
                    .expect("Missing file stem")
                    .to_str()
                    .expect("Couldn't parse file name into &str")
                    .parse::<Uuid>();

                match file_id {
                    Ok(value) => value == index,
                    Err(_) => false,
                }
            }
            Err(_) => false,
        }
    }
}

pub fn delete(storage_metadata: &mut Option<StorageMetadata>, ids: &[Uuid]) -> Result<(), String> {
    let Some(storage_metadata) = storage_metadata else{
        return Err(crate::INDEX_NOT_INITIALIZED_ERROR.to_string());
    };
    let metadata = &mut storage_metadata.metadata;

    metadata.retain(|entry| !ids.iter().any(|id| entry.id == *id));

    Ok(())
}
