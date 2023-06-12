use std::fmt::Display;

use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize)]
pub struct CollectionsResponse {
    pub data: Vec<Collection>,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct Collection {
    pub id: u32,
    pub label: String,
    pub count: u32,
}

impl Display for Collection {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{}", self.label)
    }
}

// Collection data Response
#[derive(Debug, Deserialize, Serialize)]
pub struct CollectionDataResponse {
    pub data: Vec<CollectionData>,
    pub meta: CollectionDataMeta,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct CollectionData {
    pub id: String,
    pub url: String,
    pub dimension_x: u32,
    pub dimension_y: u32,
    pub path: String,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct CollectionDataMeta {
    pub current_page: u32,
    pub last_page: u32,
    pub per_page: u32,
    pub total: u32,
}

// Image details

#[derive(Debug, Deserialize, Serialize)]
pub struct ImageDetailsResponse {
    pub data: ImageDetailsData,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct ImageDetailsData {
    pub id: String,
    pub url: String,
    pub dimension_x: u32,
    pub dimension_y: u32,
    pub path: String,
    pub tags: Vec<ImageTag>,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct ImageTag {
    pub id: u32,
    pub name: String,
}
