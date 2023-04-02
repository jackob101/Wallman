#[macro_use]
extern crate simple_log;

use clap::{arg, ArgMatches, Command, value_parser};
use simple_log::LogConfigBuilder;

use wallman_lib::{delete, download, init_storage, organize, tag_add, tag_remove};
use wallman_lib::env_config::EnvConfig;

fn cli() -> Command {
    Command::new("wallman")
        .about("Wallpapers manager")
        .arg_required_else_help(true)
        .subcommand(
            Command::new("download")
                .about("Download image from URL")
                .arg(arg!(<URL> "URL to image"))
                .arg(arg!(--tags <TAGS>).short('t').num_args(1))
                .arg_required_else_help(true),
        )
        .subcommand(
            Command::new("delete")
                .about("Remove image with passed ID")
                .arg(arg!(<ID> "Image ID. Images are stored like <ID>.<image format>")
                    .value_parser(value_parser!(u32)))
                .arg_required_else_help(true),
        )
        .subcommand(Command::new("organise").about("Organise image storage"))
        .subcommand(Command::new("tag")
            .about("Tag operations")
            .subcommand(Command::new("add")
                .about("Add tag to file")
                .arg(arg!(<FILE_NAME> "Name of the file that tag is added to"))
                .arg(arg!(<TAGS> "Tags"))
                .arg_required_else_help(true))
            .subcommand(Command::new("remove")
                .about("Remove tag from file")
                .arg(arg!(<FILE_NAME> "Name of the file"))
                .arg(arg!(<TAG> "Name of the tag to remove"))
                .arg_required_else_help(true))
        )
        .subcommand(Command::new("init")
            .about("Initialize storage"))
}

fn main() -> Result<(), String> {
    setup_logger()?;
    let env_config = EnvConfig::init();

    let matches = cli().get_matches();

    match matches.subcommand() {
        Some(("download", sub_matches)) => handle_download_operation(sub_matches, &env_config),
        Some(("delete", sub_matches)) => handle_delete_operation(sub_matches, &env_config),
        Some(("organise", _)) => organize(&env_config),
        Some(("tag", sub_matches)) => {
            match sub_matches.subcommand() {
                Some(("add", sub_matches)) => handle_tag_add_operation(sub_matches, &env_config),
                Some(("remove", sub_matches)) => handle_tag_remove_operation(sub_matches, &env_config),
                None => {}
                _ => unreachable!()
            }
        }
        Some(("init", _)) => init_storage(&env_config),
        None => {}
        _ => unreachable!(),
    }

    Ok(())
}

fn handle_download_operation(args: &ArgMatches, config: &EnvConfig) {

    let url = args.get_one::<String>("URL").expect("required");
    let file_name = download(url, config);

    if let Some(passed_tags) = args.get_one::<String>("tags"){
        tag_add(&file_name, passed_tags, config)
    }

}

fn handle_delete_operation(args: &ArgMatches, config: &EnvConfig) {
    let id = args.get_one::<u32>("ID").expect("required");
    delete(*id, config);
}

fn handle_tag_add_operation(args: &ArgMatches, config: &EnvConfig) {
    let file_name = args.get_one::<String>("FILE_NAME").expect("required");
    let tags = args.get_one::<String>("TAGS").expect("required");
    tag_add(file_name, tags, config);
}

fn handle_tag_remove_operation(args: &ArgMatches, config: &EnvConfig) {
    let file_name = args.get_one::<String>("FILE_NAME").expect("required");
    let tags = args.get_one::<String>("TAG").expect("required");
    tag_remove(file_name, tags, config);
}

fn setup_logger() -> Result<(), String> {
    let config = LogConfigBuilder::builder().output_console().build();

    simple_log::new(config)?;
    info!("Logger configured");

    Ok(())
}
