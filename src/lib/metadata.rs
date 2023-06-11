use crate::env_config::EnvConfig;
use crate::prompts::ask_for_confirmation_to_save_image;

use log::{debug, error, info};
use serde::{Deserialize, Serialize};
use std::ffi::OsString;
use std::fs::{DirEntry, File};
use std::io::BufReader;
use std::path::PathBuf;
use uuid::Uuid;

use std::borrow::{BorrowMut, ToOwned};
use std::{fs, io};

#[derive(Serialize, Deserialize, Debug, Default)]
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

#[derive(Debug)]
pub struct Collection {
    pub label: String,
    pub index: Vec<FileMetadata>,
}

impl Collection {
    pub fn persist_collection(&self, storage_metadata: &StorageMetadata) {
        let collection_dir = storage_metadata.path.join(&self.label);
        if !collection_dir.exists() {
            fs::create_dir(&collection_dir).expect("TODO: How can this fail");
        };

        let file = fs::OpenOptions::new()
            .write(true)
            .create(true)
            .truncate(true)
            .open(collection_dir.join(crate::INDEX))
            .expect("Failed to open/create file");

        serde_json::to_writer(&file, &self.index).expect("Failed to write");
    }
}

pub struct StorageMetadata {
    pub path: PathBuf,
    pub collections: Vec<Collection>,
}

impl StorageMetadata {
    pub fn new(config: &EnvConfig) -> Option<StorageMetadata> {
        let mut collections: Vec<Collection> = vec![];

        let root_directory =
            fs::read_dir(&config.storage_directory).expect("Wrong path to storage directory");

        for entry in root_directory {
            if let Err(value) = entry {
                error!("Failed to get entry in storage directory.{}", value);
                continue;
            }

            let dir = entry.unwrap().path();
            if !dir.is_dir() {
                continue;
            }

            let mut collection = fs::read_dir(&dir).expect("Failed to read collection directory");

            let index_option =
                collection.find(|entry| entry.as_ref().expect("").file_name() == *"index.json");

            if let Some(index) = index_option {
                let file = fs::read(index.expect("").path()).expect("");
                let index_parsed: Vec<FileMetadata> = serde_json::from_slice(&file).expect("");
                collections.push(Collection {
                    label: dir.file_name().expect("").to_str().expect("").to_owned(),
                    index: index_parsed,
                })
            }
        }

        Some(StorageMetadata {
            path: config.storage_directory.clone(),
            collections,
        })
    }

    pub fn add_tag_to_id(
        &mut self,
        id: Uuid,
        tags: Vec<String>,
        config: &EnvConfig,
        collection_label: String,
    ) -> Result<(), String> {
        let Some(collection) = self.get_collection_mut(&collection_label) else {
                return Err(format!(
                    "Collection with label {} was not found",
                    collection_label
                ))
        };

        let does_file_exists = fs::read_dir(&config.storage_directory.join(collection_label))
            .expect("Couldn't read storage directory")
            .any(|entry| StorageMetadata::name_with_id_predicate(id, entry));

        if !does_file_exists {
            return Err("Can't add tags to file that doesn't exists!".to_string());
        }

        let metadata_for_index_option = collection.index.iter_mut().find(|entry| entry.id.eq(&id));

        match metadata_for_index_option {
            None => {
                collection.index.push(FileMetadata::new(id, tags));
                Ok(())
            }
            Some(metadata) => {
                tags.iter()
                    .for_each(|new_tag| metadata.add_tag(new_tag).expect("Couldn't add new tag"));
                Ok(())
            }
        }
    }

    pub fn remove_tag_from_id(
        &mut self,
        id: Uuid,
        tags: Vec<String>,
        collection_label: String,
    ) -> Result<(), String> {
        let Some(collection) = self.get_collection_mut( &collection_label)else{
                return Err(format!(
                    "Collection with label {} was not found",
                    collection_label
                ))
        };
        let metadata_for_index_option = collection.index.iter_mut().find(|entry| entry.id.eq(&id));

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

    pub fn query(
        &self,
        tags: Vec<String>,
        collection_label: String,
    ) -> Result<Vec<&FileMetadata>, String> {
        let Some(collection) = self.get_collection(&collection_label)else {
                return Err(format!(
                    "Collection with label {} was not found",
                    collection_label
                ))
        };
        if tags.is_empty() {
            return Ok(collection.index.iter().collect());
        }

        let mut matching_elements: Vec<&FileMetadata> = vec![];

        for entry in &collection.index {
            if entry.contains_tags(&tags) {
                matching_elements.push(&entry);
            }
        }

        Ok(matching_elements)
    }

    pub fn persist(&self) {
        info!("persisting {}", crate::INDEX);

        for collection in &self.collections {
            let collection_dir = &self.path.join(&collection.label);
            if !collection_dir.exists() {
                fs::create_dir(collection_dir).expect("TODO: How can this fail");
            };

            let file = fs::OpenOptions::new()
                .write(true)
                .create(true)
                .truncate(true)
                .open(collection_dir.join(crate::INDEX))
                .expect("Failed to open/create file");

            serde_json::to_writer(&file, &collection.index).expect("Failed to write");
        }
    }

    pub fn get_collection(&self, collection_label: &str) -> Option<&Collection> {
        self.collections
            .iter()
            .find(|entry| entry.label == *collection_label)
    }

    pub fn get_collection_mut(&mut self, collection_label: &str) -> Option<&mut Collection> {
        self.collections
            .iter_mut()
            .find(|entry| entry.label == *collection_label)
    }

    pub fn get_collection_owned(&mut self, collection_label: &str) -> Collection {
        let position = self
            .collections
            .iter()
            .position(|entry| entry.label == collection_label);

        match position {
            Some(value) => self.collections.swap_remove(value),
            None => Collection {
                label: collection_label.to_owned(),
                index: vec![],
            },
        }
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

pub fn delete(
    storage_metadata: &mut Option<StorageMetadata>,
    ids: &[Uuid],
    collection_label: String,
) -> Result<(), String> {
    let Some(storage_metadata) = storage_metadata else{
        return Err(crate::INDEX_NOT_INITIALIZED_ERROR.to_string());
    };

    let Some(collection) = storage_metadata.get_collection_mut(&collection_label) else{
                return Err(format!(
                    "Collection with label {} was not found",
                    collection_label
                ))
    };
    let metadata = &mut collection.index;

    metadata.retain(|entry| !ids.iter().any(|id| entry.id == *id));

    Ok(())
}
