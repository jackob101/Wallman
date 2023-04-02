use csv::StringRecord;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
pub struct MetaData {
    pub file_name: String,
    pub tags: Vec<String>,
}


impl MetaData {

    pub fn new(file_name: String, tags: Vec<String>) -> MetaData {
        MetaData {
            file_name,
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
}