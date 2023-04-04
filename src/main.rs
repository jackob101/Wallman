#[macro_use]
extern crate simple_log;
extern crate core;

use clap::{arg, ArgMatches, Command, value_parser};
use simple_log::LogConfigBuilder;

use wallman_lib::{delete, download, init_storage, organize, tag_add, tag_remove};
use wallman_lib::env_config::EnvConfig;
use wallman_lib::tag::IndexData;

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
                .arg(arg!(<ID> "ID of the file")
                    .value_parser(value_parser!(u32)))
                .arg(arg!(<TAGS> "Tags"))
                .arg_required_else_help(true))
            .subcommand(Command::new("remove")
                .about("Remove tag from file")
                .arg(arg!(<ID> "ID of the file")
                    .value_parser(value_parser!(u32)))
                .arg(arg!(<TAG> "Name of the tag to remove"))
                .arg_required_else_help(true))
        )
        .subcommand(Command::new("init")
            .about("Initialize storage"))
        .subcommand(Command::new("drop")
            .about("Test for drop"))
}

fn main() -> Result<(), String> {
    setup_logger()?;
    let env_config = EnvConfig::init();
    let mut index_data = IndexData::init(&env_config);

    let matches = cli().get_matches();

    match matches.subcommand() {
        Some(("download", sub_matches)) => handle_download_operation(sub_matches, &env_config),
        Some(("delete", sub_matches)) => handle_delete_operation(sub_matches, &env_config),
        Some(("organise", _)) => organize(&env_config),
        Some(("tag", sub_matches)) => {
            match sub_matches.subcommand() {
                Some(("add", sub_matches)) => handle_tag_add_operation(sub_matches, &mut index_data, &env_config)?,
                Some(("remove", sub_matches)) => handle_tag_remove_operation(sub_matches, &mut index_data)?,
                None => {}
                _ => unreachable!()
            }
        }
        Some(("init", _)) => init_storage(&env_config),
        Some(("drop", _)) => {IndexData::init(&env_config);},
        None => {}
        _ => unreachable!(),
    }

    Ok(())
}

fn handle_download_operation(args: &ArgMatches, config: &EnvConfig) {

    let url = args.get_one::<String>("URL").expect("required");
    let file_name = download(url, config);

    if let Some(passed_tags) = args.get_one::<String>("tags"){
        tag_add(file_name.index, passed_tags, config)
    }

}

fn handle_delete_operation(args: &ArgMatches, config: &EnvConfig) {
    let id = args.get_one::<u32>("ID").expect("required");
    delete(*id, config);
}

fn handle_tag_add_operation(args: &ArgMatches, index_data: &mut IndexData, config: &EnvConfig) -> Result<(), String> {
    let index = args.get_one::<u32>("ID").expect("required");
    let tags = args.get_one::<String>("TAGS").expect("required");
    index_data.add_tag(*index, tags, config)
}

fn handle_tag_remove_operation(args: &ArgMatches, index_data: &mut IndexData) -> Result<(), String>{
    let index = args.get_one::<u32>("ID").expect("required");
    let tags = args.get_one::<String>("TAG").expect("required");
    index_data.remove_tag(*index, tags)
}

fn setup_logger() -> Result<(), String> {
    let config = LogConfigBuilder::builder().output_console().build();

    simple_log::new(config)?;
    info!("Logger configured");

    Ok(())
}
