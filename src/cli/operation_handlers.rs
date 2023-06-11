use wallman_lib::env_config::EnvConfig;
use wallman_lib::metadata::StorageMetadata;
use wallman_lib::reddit::operations;
use wallman_lib::{metadata, storage, wallheaven};

use super::{Cli, Commands, ImageOperation, ImageOperationTag, IndexOperation, RedditOperation};

pub fn handle_operation(
    cli: Cli,
    config: &EnvConfig,
    storage_metadata: &mut Option<StorageMetadata>,
) -> Result<(), String> {
    match cli.command {
        Commands::Index(index) => match index {
            IndexOperation::Init { collection } => {
                storage::init_storage(config, &collection);
                Ok(())
            }
            IndexOperation::Fix { collection } => {
                storage::fix_storage(config, storage_metadata, collection)
            }
            IndexOperation::Restore { collection } => match storage_metadata {
                Some(value) => storage::restore(value, config, collection),
                None => Err("Index is not initialized".to_string()),
            },
        },
        Commands::Reddit(reddit) => match reddit {
            RedditOperation::Authorize => {
                operations::ask_user_for_grants_to_account(config);
                Ok(())
            }
            RedditOperation::AcceptRedirect { uri } => {
                operations::handle_authorization_redirect(uri, config)
            }
            RedditOperation::Sync {
                upvoted_posts_fetch_limit,
            } => operations::sync(upvoted_posts_fetch_limit, config, storage_metadata),
        },
        Commands::Image(image) => match image {
            ImageOperation::Download {
                url,
                tags: tag,
                collection,
            } => {
                let saved_image = storage::download(&url, config);

                if let Some(tag) = tag {
                    if !tag.is_empty() {
                        println!("Adding tags to image with ID: {}", saved_image.index);
                        if let Some(storage_metadata) = storage_metadata {
                            storage_metadata.add_tag_to_id(
                                saved_image.index,
                                tag,
                                config,
                                collection,
                            )?;
                        }
                    }
                }
                Ok(())
            }
            ImageOperation::Delete {
                ids: id,
                collection,
            } => {
                let deleted_files = storage::delete(&id, config, &collection)?;

                metadata::delete(storage_metadata, &deleted_files, collection)
            }
            ImageOperation::Tag(tag_operation) => match tag_operation {
                ImageOperationTag::Add {
                    id,
                    tags: tag,
                    collection,
                } => match storage_metadata {
                    Some(value) => value.add_tag_to_id(id, tag, config, collection),
                    None => Err("Index is not initialized".to_string()),
                },
                ImageOperationTag::Delete {
                    id,
                    tags,
                    collection,
                } => match storage_metadata {
                    Some(value) => value.remove_tag_from_id(id, tags, collection),
                    None => Err("Index is not initialized".to_string()),
                },
                ImageOperationTag::Clear { id, collection } => {
                    metadata::delete(storage_metadata, &[id], collection)
                }
            },
        },
        Commands::Query { tags, collection } => match storage_metadata {
            Some(value) => {
                value
                    .query(tags, collection)?
                    .iter()
                    .for_each(|entry| println!("ID: {}", entry.id));
                Ok(())
            }
            None => Err("Index is not initialized".to_string()),
        },
        Commands::Wallheaven(operation) => match operation {
            super::WallheavenOperation::Sync => {
                wallheaven::sync(storage_metadata.as_mut().unwrap(), config)
            }
        },
    }
}
