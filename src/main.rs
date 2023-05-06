mod commands;

#[macro_use]
extern crate simple_log;
extern crate core;

use clap::ArgMatches;
use simple_log::LogConfigBuilder;

use wallman_lib::env_config::EnvConfig;
use wallman_lib::metadata::{FileMetadata, StorageMetadata};
use wallman_lib::{init_storage, metadata, storage};

fn main() -> Result<(), String> {
    setup_logger()?;
    let env_config = EnvConfig::init();
    let mut storage_metadata = StorageMetadata::new(&env_config);

    let matches = commands::generate_commands().get_matches();

    match matches.subcommand() {
        Some(("image", sub_matchers)) => {
            match_image_command(sub_matchers, &env_config, &mut storage_metadata)?
        }
        Some(("organise", _)) => {
            let moved_files = storage::organise(&env_config);
            storage_metadata.move_all_tags(&moved_files);
        }
        Some(("index", sub_matches)) => {
            match sub_matches.subcommand() {
                Some(("init", _)) => init_storage(&env_config),
                Some(("fix", _)) => wallman_lib::fix_storage(&env_config, &mut storage_metadata)?,
                None => {}
                _ => unreachable!(),
            }

            init_storage(&env_config)
        }
        Some(("query", sub_matches)) => {
            handle_query_operation(sub_matches, &storage_metadata);
        }
        None => {}
        _ => unreachable!(),
    }

    storage_metadata.persist();

    Ok(())
}

fn match_image_command(
    sub_matchers: &ArgMatches,
    config: &EnvConfig,
    storage_metadata: &mut StorageMetadata,
) -> Result<(), String> {
    match sub_matchers.subcommand() {
        Some(("download", sub_matches)) => {
            handle_download_operation(sub_matches, config, storage_metadata)
        }
        Some(("delete", sub_matches)) => {
            handle_delete_operation(sub_matches, config, storage_metadata)
        }
        Some(("tag", sub_matches)) => match sub_matches.subcommand() {
            Some(("add", sub_matches)) => {
                handle_tag_add_operation(sub_matches, storage_metadata, config)
            }
            Some(("delete", sub_matches)) => {
                handle_tag_remove_operation(sub_matches, storage_metadata)
            }
            Some(("clear", sub_matches)) => {
                handle_tag_clear_operation(sub_matches, storage_metadata)
            }
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
    let tags = args
        .get_many::<String>("tags")
        .map(|entry| entry.map(|s| s.to_string()).collect::<Vec<_>>())
        .unwrap_or_default();

    let file_name = storage::download(url, config);

    if !tags.is_empty() {
        storage_metadata.add_tag_to_id(file_name.index, tags, config)?;
    }

    Ok(())
}

fn handle_delete_operation(
    args: &ArgMatches,
    config: &EnvConfig,
    storage_metadata: &mut StorageMetadata,
) -> Result<(), String> {
    let ids = args.get_many::<u32>("ID").expect("required");

    let ids = ids.copied().collect::<Vec<u32>>();

    let deleted_files = storage::delete(&ids, config)?;

    metadata::delete(storage_metadata, &deleted_files);

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
    index_data.add_tag_to_id(*index, tags, config)
}

fn handle_tag_remove_operation(
    args: &ArgMatches,
    index_data: &mut StorageMetadata,
) -> Result<(), String> {
    let index = args.get_one::<u32>("ID").expect("required");
    let tags = args.get_many::<String>("TAGS").expect("required");
    let tags = tags.map(|tag| tag.to_string()).collect::<Vec<String>>();
    index_data.remove_tag_from_id(*index, tags)
}

fn handle_tag_clear_operation(
    args: &ArgMatches,
    storage_metadata: &mut StorageMetadata,
) -> Result<(), String> {
    let id = args.get_one::<u32>("ID").expect("Missing argument");
    metadata::delete(storage_metadata, &[*id]);
    Ok(())
}

fn handle_query_operation(args: &ArgMatches, storage_metadata: &StorageMetadata) {
    let tags: Vec<String> = args
        .get_many::<String>("TAGS")
        .map(|entry| entry.map(|tag| tag.to_string()).collect())
        .unwrap_or_default();

    match storage_metadata.query(tags) {
        Ok(value) => {
            value.iter().for_each(|entry| println!("ID: {}", entry.id));
        }
        Err(_) => {todo!()}
    }
}

fn setup_logger() -> Result<(), String> {
    let config = LogConfigBuilder::builder().output_console().build();

    simple_log::new(config)?;
    info!("Logger configured");

    Ok(())
}
