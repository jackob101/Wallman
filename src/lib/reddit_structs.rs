#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct UpvotedResponse {
    data: UpvotedResponseData,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct UpvotedResponseData {
    children: Vec<T3>,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct T3 {
    data: T3Data,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct T3Data {
    subreddit: String,
    preview: Option<Preview>,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct Preview {
    images: Vec<Images>,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct Images {
    source: Image,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct Image {
    url: String,
    width: u32,
    height: u32,
}
