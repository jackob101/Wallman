use image::ImageFormat;
use std::fmt::Debug;
use std::path::PathBuf;

use crate::utils;

#[derive(Debug)]
pub struct SimpleFile {
    pub index: u32,
    pub format: ImageFormat,
}

impl SimpleFile {
    pub fn new(index: u32, extension: ImageFormat) -> SimpleFile {
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
