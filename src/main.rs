mod commands;

#[macro_use]
extern crate simple_log;
extern crate core;

use clap::parser::ValuesRef;
use clap::ValueHint::CommandString;
use clap::{arg, value_parser, ArgMatches, Command};
use simple_log::LogConfigBuilder;

use wallman_lib::env_config::EnvConfig;
use wallman_lib::tag::StorageMetadata;
use wallman_lib::{delete, download, init_storage, organize};

fn main() -> Result<(), String> {
    setup_logger()?;
    let env_config = EnvConfig::init();
    let mut storage_metadata = StorageMetadata::init(&env_config);

    let matches = commands::generate_commands().get_matches();

    match matches.subcommand() {
        Some(("image", sub_matchers)) => {
            match_image_command(sub_matchers, &env_config, &mut storage_metadata)?
        }
        Some(("organise", _)) => organize(&env_config, &mut storage_metadata),
        Some(("index", sub_matches)) => {
            match sub_matches.subcommand() {
                Some(("init", _)) => init_storage(&env_config),
                Some(("fix", _)) => wallman_lib::fix_storage(&env_config, &mut storage_metadata),
                None => {}
                _ => unreachable!(),
            }

            init_storage(&env_config)
        }
        Some(("drop", _)) => {
            StorageMetadata::init(&env_config);
        }
        None => {}
        _ => unreachable!(),
    }

    Ok(())
}

fn match_image_command(
    sub_matchers: &ArgMatches,
    config: &EnvConfig,
    storage_metadata: &mut StorageMetadata,
) -> Result<(), String> {
    match sub_matchers.subcommand() {
        Some(("download", sub_matches)) => {
            handle_download_operation(sub_matches, &config, storage_metadata)
        }
        Some(("delete", sub_matches)) => {
            handle_delete_operation(sub_matches, &config, storage_metadata)
        }
        Some(("tag", sub_matches)) => match sub_matches.subcommand() {
            Some(("add", sub_matches)) => {
                handle_tag_add_operation(sub_matches, storage_metadata, &config)
            }
            Some(("delete", sub_matches)) => {
                handle_tag_remove_operation(sub_matches, storage_metadata)
            }
            Some(("clear", sub_matches)) => {
                handle_tag_clear_operation(sub_matches, storage_metadata)
            },
            None => Err("None matched".to_string()),
            _ => unreachable!(),
        },
        None => Err("None matched".to_string()),
        _ => Ok(()),
    }
}

fn handle_download_operation(
    args: &ArgMatches,
    config: &EnvConfig,
    storage_metadata: &mut StorageMetadata,
) -> Result<(), String> {
    let url = args.get_one::<String>("URL").expect("required");
    let file_name = download(url, config);

    if let Some(passed_tags) = args.get_one::<String>("tags") {
        storage_metadata.add_tag_to_file(file_name.index, vec![passed_tags.to_string()], config)?;
    };

    Ok(())
}

fn handle_delete_operation(
    args: &ArgMatches,
    config: &EnvConfig,
    index_data: &mut StorageMetadata,
) -> Result<(), String> {
    let id = args.get_one::<u32>("ID").expect("required");

    let have_file_been_deleted = delete(*id, config)?;

    if have_file_been_deleted {
        index_data.remove_all_tags_from_file(*id);
    };

    Ok(())
}

fn handle_tag_add_operation(
    args: &ArgMatches,
    index_data: &mut StorageMetadata,
    config: &EnvConfig,
) -> Result<(), String> {
    let index = args.get_one::<u32>("ID").expect("required");
    let tags = args.get_many::<String>("TAGS").expect("required");
    let tags = tags.map(|tag| tag.to_string()).collect::<Vec<String>>();
    index_data.add_tag_to_file(*index, tags, config)
}

fn handle_tag_remove_operation(
    args: &ArgMatches,
    index_data: &mut StorageMetadata,
) -> Result<(), String> {
    let index = args.get_one::<u32>("ID").expect("required");
    let tags = args.get_many::<String>("TAGS").expect("required");
    let tags = tags.map(|tag| tag.to_string()).collect::<Vec<String>>();
    index_data.remove_tag_from_file(*index, tags)
}

fn handle_tag_clear_operation(
    args: &ArgMatches,
    storage_metadata: &mut StorageMetadata
) -> Result<(), String>{
    let id = args.get_one::<u32>("ID").expect("Missing argument");
    storage_metadata.remove_all_tags_from_file(*id)
}

fn setup_logger() -> Result<(), String> {
    let config = LogConfigBuilder::builder().output_console().build();

    simple_log::new(config)?;
    info!("Logger configured");

    Ok(())
}
