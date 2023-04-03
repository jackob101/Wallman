use std::ops::Index;
use csv::StringRecord;
use serde::{Deserialize, Serialize};

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

    pub fn add_tag(&mut self, new_tag: &String){
        self.tags.push(new_tag.to_owned());
    }

    pub fn remove_tag(&mut self, tag_name: &String) -> Result<(), String> {

        let old_size = self.tags.len();

        self.tags.retain(|entry| !entry.eq(tag_name));

        if old_size == self.tags.len() {
            return Err(format!("Tag {} doesn't exists for file {}", tag_name, self.index));
        }

        Ok(())
    }
}