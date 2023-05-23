extern crate core;

pub mod env_config;
pub mod metadata;
pub mod reddit;
pub mod reddit_structs;
pub mod simple_file;
pub mod storage;

pub const INDEX: &str = "index.json";
pub const INDEX_NOT_INITIALIZED_ERROR: &str = "index.json is not initialized";
