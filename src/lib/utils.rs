use image::ImageFormat;

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
