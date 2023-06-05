use std::io::{stdin, BufRead, Write};

pub fn ask_for_confirmation_to_save_image() -> bool {
    print!("Save image? (Y/n): ");
    std::io::stdout().flush().expect("FLUSH");

    let mut user_response = "".to_string();
    std::io::stdin()
        .lock()
        .read_line(&mut user_response)
        .expect("TODO Handle error during input");

    let user_response = user_response.trim();

    println!();
    user_response.is_empty() || user_response.eq_ignore_ascii_case("y")
}

pub fn ask_for_additional_tags() -> Vec<String> {
    print!("Additional tags ( separated by SPACE ): ");
    std::io::stdout().flush().expect("FLUSH");

    let mut additional_tags = "".to_string();
    std::io::stdin()
        .lock()
        .read_line(&mut additional_tags)
        .expect("TODO Handle error during input");

    println!();

    additional_tags
        .trim()
        .split(' ')
        .filter(|tag| !tag.is_empty())
        .map(|e| e.trim().to_owned())
        .collect()
}

pub fn ask_for_resolution(default_width: u32, default_height: u32) -> (u32, u32) {
    println!(
        "Choose resolution (Default {}x{})",
        default_width, default_height
    );
    println!("1: 1920x1080");
    println!("2: 2048x1080");
    println!("3: 3840x2160");
    println!("4: 4096x2160");
    println!("5: custom");
    std::io::stdout().flush().expect("FLUSH");

    let mut user_input = "".to_owned();

    loop {
        print!("Option: ");
        std::io::stdout().flush().expect("FLUSH");
        stdin()
            .lock()
            .read_line(&mut user_input)
            .expect("Failed to read user input");

        let resolution = match user_input.trim() {
            "" => (default_width, default_height),
            "1" => (1920, 1080),
            "2" => (2048, 1080),
            "3" => (3840, 2160),
            "4" => (4096, 2160),
            _ => {
                println!("Please pick resolution from list");
                continue;
            }
        };

        println!();
        return resolution;
    }
}
