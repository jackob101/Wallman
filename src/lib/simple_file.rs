use image::ImageFormat;
use std::fmt::Debug;
use std::path::PathBuf;
use uuid::Uuid;

use crate::utils;

#[derive(Debug)]
pub struct SimpleFile {
    pub index: Uuid,
    pub format: ImageFormat,
}

impl SimpleFile {
    pub fn new(index: Uuid, extension: ImageFormat) -> SimpleFile {
        SimpleFile {
            index,
            format: extension,
        }
    }

    pub fn to_path(&self) -> PathBuf {
        PathBuf::from(utils::format_filename_and_extension(
            &self.index.to_string(),
            self.format,
        ))
    }
}
