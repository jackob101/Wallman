use std::borrow::Cow;
use std::collections::HashMap;
use std::fs;
use std::str::FromStr;

use clap::ArgMatches;

use wallman_lib::env_config::EnvConfig;
use wallman_lib::metadata::StorageMetadata;
use wallman_lib::{metadata, reddit, storage};

pub fn handle(
    matches: &ArgMatches,
    config: &EnvConfig,
    storage_metadata: &mut StorageMetadata,
) -> Result<(), String> {
    match matches.subcommand() {
        Some(("image", sub_matchers)) => {
            match_image_command(sub_matchers, config, storage_metadata)
        }
        Some(("organise", _)) => {
            let moved_files = storage::organise(config);
            storage_metadata.move_all_tags(&moved_files)
        }
        Some(("index", sub_matches)) => {
            match sub_matches.subcommand() {
                Some(("init", _)) => wallman_lib::storage::init_storage(config),
                Some(("fix", _)) => wallman_lib::storage::fix_storage(config, storage_metadata)?,
                None => {}
                _ => unreachable!(),
            }
            wallman_lib::storage::init_storage(config);
            Ok(())
        }
        Some(("query", sub_matches)) => handle_query_operation(sub_matches, storage_metadata),
        Some(("reddit", sub_matches)) => {
            match_reddit_operation(sub_matches, config, storage_metadata)
        }
        None => Err("Failed to match operation".to_owned()),
        _ => unreachable!(),
    }
}

pub fn handle_delete_operation(
    args: &ArgMatches,
    config: &EnvConfig,
    storage_metadata: &mut StorageMetadata,
) -> Result<(), String> {
    let ids = args.get_many::<u32>("ID").expect("required");

    let ids = ids.copied().collect::<Vec<u32>>();

    let deleted_files = storage::delete(&ids, config)?;

    metadata::delete(storage_metadata, &deleted_files)
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

fn match_reddit_operation(
    args: &ArgMatches,
    config: &EnvConfig,
    storage_metadata: &StorageMetadata,
) -> Result<(), String> {
    match args.subcommand() {
        Some(("authorize", _)) => {
            reddit::ask_for_grants();
        }
        Some(("accept_redirect", sub_matches)) => {
            reddit::handle_authorization_redirect(sub_matches, config);
        }
        Some(_) => {
            unreachable!("If this happens, then there is mismatch between commands and handler")
        }
        None => todo!(),
    }
    Ok(())
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
    metadata::delete(storage_metadata, &[*id])
}

fn handle_query_operation(
    args: &ArgMatches,
    storage_metadata: &StorageMetadata,
) -> Result<(), String> {
    let tags: Vec<String> = args
        .get_many::<String>("TAGS")
        .map(|entry| entry.map(|tag| tag.to_string()).collect())
        .unwrap_or_default();

    storage_metadata
        .query(tags)?
        .iter()
        .for_each(|entry| println!("ID: {}", entry.id));

    Ok(())
}
