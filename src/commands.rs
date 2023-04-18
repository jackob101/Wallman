use clap::{arg, value_parser, Command};

pub fn generate_commands() -> Command {
    Command::new("wallman")
        .about("Wallpapers manager")
        .arg_required_else_help(true)
        .subcommand(generate_download())
        .subcommand(generate_delete())
        .subcommand(generate_organise())
        .subcommand(generate_tag())
        .subcommand(generate_index())
}

fn generate_index() -> Command {
    Command::new("index")
        .about("Subcommands for managing index.csv")
        .subcommand(Command::new("init").about("Initialize storage"))
        .subcommand(
            Command::new("fix")
                .about("Try to fix index.csv. ( Remove ID's that leads to missing files )"),
        )
}

fn generate_tag() -> Command {
    Command::new("tag")
        .about("Tag operations")
        .subcommand(
            Command::new("add")
                .about("Add tag to file")
                .arg(arg!(<ID> "ID of the file").value_parser(value_parser!(u32)))
                .arg(arg!(<TAGS> "Tags"))
                .arg_required_else_help(true),
        )
        .subcommand(
            Command::new("remove")
                .about("Remove tag from file")
                .arg(arg!(<ID> "ID of the file").value_parser(value_parser!(u32)))
                .arg(arg!(<TAG> "Name of the tag to remove"))
                .arg_required_else_help(true),
        )
}

fn generate_organise() -> Command {
    Command::new("organise").about("Organise image storage")
}

fn generate_delete() -> Command {
    Command::new("delete")
        .about("Remove image with passed ID")
        .arg(
            arg!(<ID> "Image ID. Images are stored like <ID>.<image format>")
                .value_parser(value_parser!(u32)),
        )
        .arg_required_else_help(true)
}

fn generate_download() -> Command {
    Command::new("download")
        .about("Download image from URL")
        .arg(arg!(<URL> "URL to image"))
        .arg(arg!(--tags <TAGS>).short('t').num_args(1))
        .arg_required_else_help(true)
}
