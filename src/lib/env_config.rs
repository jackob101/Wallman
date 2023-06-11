use std::env::{self, vars};

use std::path::PathBuf;

pub struct EnvConfig {
    pub storage_directory: PathBuf,
    pub wallheaven_username: Option<String>,
}

impl EnvConfig {
    pub fn init() -> EnvConfig {
        let storage_directory = match env::var("WALLMAN_STORAGE_DIRECTORY") {
            Ok(value) => PathBuf::from(value),
            Err(_) => home::home_dir().unwrap().join("Wallpapers"),
        };

        let wallheaven_username = match env::var("WALLMAN_WALLHEAVEN_USERNAME") {
            Ok(value) => Some(value),
            Err(_) => None,
        };

        EnvConfig {
            storage_directory,
            wallheaven_username,
        }
    }
}
