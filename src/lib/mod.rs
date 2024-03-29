extern crate core;

pub mod env_config;
pub mod metadata;
pub mod prompts;
pub mod reddit;
pub mod simple_file;
pub mod storage;
pub mod utils;
pub mod wallheaven;

pub const INDEX: &str = "index.json";
pub const INDEX_NOT_INITIALIZED_ERROR: &str = "index.json is not initialized";
