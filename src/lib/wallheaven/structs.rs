use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize)]
pub struct CollectionsResponse {
    data: Vec<Collection>,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct Collection {
    id: u32,
    label: String,
    count: u32,
}
