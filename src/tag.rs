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
            return Err(format!(
                "Tag {} doesn't exists for file {}",
                tag_name, self.index
            ));
        }

        Ok(())
    }

    pub fn move_tag(&mut self, to: u32) {
        self.index = to;
    }
}

pub struct StorageMetadata {
    path: PathBuf,
    pub metadata: Vec<FileMetadata>,
}

impl StorageMetadata {
    pub fn init(config: &EnvConfig) -> StorageMetadata {
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

    pub fn add_tag_to_file(
        &mut self,
        index: u32,
        tags: Vec<String>,
        config: &EnvConfig,
    ) -> Result<(), String> {
        let does_file_exists = fs::read_dir(&config.storage_directory)
            .expect("Couldn't read storage directory")
            .any(|entry| StorageMetadata::name_with_id_predicate(index, entry));

        if !does_file_exists {
            return Err("Can't add tags to file that doesn't exists!".to_string());
        }

        let metadata_for_index_option = self
            .metadata
            .iter_mut()
            .find(|entry| entry.index.eq(&index));

        match metadata_for_index_option {
            None => {
                self.metadata.push(FileMetadata::new(index, tags));
                Ok(())
            }
            Some(metadata) => {
                tags.iter()
                    .for_each(|new_tag| metadata.add_tag(new_tag).expect("Couldn't add new tag"));
                Ok(())
            }
        }
    }

    pub fn remove_tag_from_file(&mut self, index: u32, tags: Vec<String>) -> Result<(), String> {
        let metadata_for_index_option = self
            .metadata
            .iter_mut()
            .find(|entry| entry.index.eq(&index));

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

    pub fn remove_all_tags_from_file(&mut self, index: u32) {
        self.metadata.retain(|entry| entry.index != index);
    }

    pub fn move_index(&mut self, from: u32, to: u32) -> Result<(), String> {
        let found_metatadata_about_file =
            self.metadata.iter_mut().find(|entry| entry.index == from);

        match found_metatadata_about_file {
            None => Err("Index not found".to_string()),
            Some(value) => {
                value.move_tag(to);
                Ok(())
            }
        }
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

impl Drop for StorageMetadata {
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
            writer
                .serialize(file_meta_data)
                .expect("Couldn't serialize record");
        }

        writer.flush().expect("Couldn't flush writer");
    }
}
