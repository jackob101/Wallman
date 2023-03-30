use std::env;

use std::path::PathBuf;

pub struct EnvConfig {
    pub storage_directory: PathBuf,
}

impl EnvConfig {
    pub fn init() -> EnvConfig {

        let storage_directory = match env::var("WALLMAN_STORAGE_DIRECTORY") {
            Ok(value) => PathBuf::from(value),
            Err(_) => home::home_dir().unwrap().join("Wallpapers")
        };


        EnvConfig {
            storage_directory
        }
    }
}



