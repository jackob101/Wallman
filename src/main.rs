#[macro_use]
extern crate simple_log;

use clap::{arg, ArgMatches, Command, value_parser};
use simple_log::LogConfigBuilder;

use wallman_lib::{delete, download, init_storage, organize, tag_add};
use wallman_lib::env_config::EnvConfig;

fn cli() -> Command {
    Command::new("wallman")
        .about("Wallpapers manager")
        .arg_required_else_help(true)
        .subcommand(
            Command::new("download")
                .about("Download image from URL")
                .arg(arg!(<URL> "URL to image"))
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
            .arg(arg!(<FILE_NAME> "Name of the file that tag is added to"))
            .arg(arg!(<TAGS> "Tags"))
            .arg_required_else_help(true))
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
        Some(("tag", sub_matches)) => handle_tag_add_operation(sub_matches, &env_config),
        Some(("init", _)) => init_storage(&env_config),
        None => {}
        _ => unreachable!(),
    }

    Ok(())
}

fn handle_download_operation(args: &ArgMatches, config: &EnvConfig) {
    let url = args.get_one::<String>("URL").expect("required");
    download(url, config);
}

fn handle_delete_operation(args: &ArgMatches, config: &EnvConfig ) {
    let id = args.get_one::<u32>("ID").expect("required");
    delete(*id, config);
}

fn handle_tag_add_operation(args: &ArgMatches, config: &EnvConfig){
    let file_name = args.get_one::<String>("FILE_NAME").expect("required");
    let tags = args.get_one::<String>("TAGS").expect("required");
    tag_add(file_name, tags, config);
}

fn setup_logger() -> Result<(), String> {
    let config = LogConfigBuilder::builder().output_console().build();

    simple_log::new(config)?;
    info!("Logger configured");

    Ok(())
}
