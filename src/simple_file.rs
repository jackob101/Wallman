use image::ImageFormat;
use std::fmt::{Debug, Formatter};
use std::path::PathBuf;

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
        PathBuf::from(format!(
            "{}.{}",
            self.index,
            self.format.extensions_str()[0]
        ))
    }
}
