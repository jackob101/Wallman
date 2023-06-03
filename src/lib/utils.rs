use std::io::{stdout, Write};

use base64::Engine;
use image::{DynamicImage, ImageFormat};

pub fn extract_filename_from_url(url: &str) -> Result<&str, &str> {
    let question_mark_index = match url.find('?') {
        Some(value) => value,
        None => return Err("url doesn't contain '?'"),
    };

    let end_of_domain_index = match url.find("it/") {
        Some(value) => value,
        None => return Err("URL doesn't contain 'it/'"),
    };

    let url_filename = &url[end_of_domain_index + 3..question_mark_index];

    Ok(url_filename)
}

pub fn format_filename_and_extension(filename: &str, extension: ImageFormat) -> String {
    format!("{}.{}", filename, extension.extensions_str()[0])
}

pub fn print(image: &DynamicImage) {
    let width = image.width().to_string();
    let height = image.height().to_string();

    let rgba = image.to_rgba8();
    let raw = rgba.as_raw();
    let encoded_data = base64::engine::general_purpose::STANDARD.encode(raw);
    let mut iter = encoded_data.chars().peekable();

    let first_chunk: String = iter.by_ref().take(4096).collect();

    print!(
        "\x1b_Gf=32,a=T,t=d,s={},v={},c=60,r=20,m=1;{}\x1b\\",
        width, height, first_chunk
    );

    while iter.peek().is_some() {
        let chunk: String = iter.by_ref().take(4096).collect();
        let m = if iter.peek().is_some() { 1 } else { 0 };
        print!("\x1b_Gm={};{}\x1b\\", m, chunk);
    }

    println!();
    stdout().flush();
}
