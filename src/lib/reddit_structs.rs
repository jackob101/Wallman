// Upvote response model

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct UpvotedResponse {
    pub data: UpvotedResponseData,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct UpvotedResponseData {
    pub children: Vec<T3>,
    pub after: Option<String>,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct T3 {
    pub data: T3Data,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct T3Data {
    pub subreddit: String,
    pub preview: Option<Preview>,
    pub permalink: String,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct Preview {
    pub images: Vec<Images>,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct Images {
    pub source: Image,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct Image {
    pub url: String,
    pub width: u32,
    pub height: u32,
}

pub struct PostInformations {
    pub permalink: String,
    pub image_url: String,
}

// Other models

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct Authorization {
    pub access_token: String,
    pub token_type: String,
    pub expires_in: u32,
    pub refresh_token: String,
    pub scope: String,
}

#[derive(Debug, serde::Serialize, serde::Deserialize)]
pub struct UserResponse {
    pub name: String,
}
