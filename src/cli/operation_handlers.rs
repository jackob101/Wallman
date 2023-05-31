use wallman_lib::env_config::EnvConfig;
use wallman_lib::metadata::StorageMetadata;
use wallman_lib::reddit::operations;
use wallman_lib::{metadata, storage};

use super::{Cli, Commands, ImageOperation, ImageOperationTag, IndexOperation, RedditOperation};

pub fn handle_operation(
    cli: Cli,
    config: &EnvConfig,
    storage_metadata: &mut StorageMetadata,
) -> Result<(), String> {
    match cli.command {
        Commands::Index(index) => match index {
            IndexOperation::Init => {
                storage::init_storage(config);
                Ok(())
            }
            IndexOperation::Fix => storage::fix_storage(config, storage_metadata),
        },
        Commands::Reddit(reddit) => match reddit {
            RedditOperation::Authorize => {
                operations::ask_user_for_grants_to_account(config);
                Ok(())
            }
            RedditOperation::AcceptRedirect { uri } => {
                operations::handle_authorization_redirect(uri, config)
            }
            RedditOperation::Sync => operations::sync(config, storage_metadata),
        },
        Commands::Image(image) => match image {
            ImageOperation::Download { url, tags: tag } => {
                let saved_image = storage::download(&url, config);

                if let Some(tag) = tag {
                    if !tag.is_empty() {
                        println!("Adding tags to image with ID: {}", saved_image.index);
                        storage_metadata.add_tag_to_id(saved_image.index, tag, config)?;
                    }
                }
                Ok(())
            }
            ImageOperation::Delete { ids: id } => {
                let deleted_files = storage::delete(&id, config)?;

                metadata::delete(storage_metadata, &deleted_files)
            }
            ImageOperation::Tag(tag_operation) => match tag_operation {
                ImageOperationTag::Add { id, tags: tag } => {
                    storage_metadata.add_tag_to_id(id, tag, config)
                }
                ImageOperationTag::Delete { id, tags } => {
                    storage_metadata.remove_tag_from_id(id, tags)
                }
                ImageOperationTag::Clear { id } => metadata::delete(storage_metadata, &[id]),
            },
        },
        Commands::Query { tags } => {
            storage_metadata
                .query(tags)?
                .iter()
                .for_each(|entry| println!("ID: {}", entry.id));

            Ok(())
        }
        Commands::Organise => {
            let moved_files = storage::organise(config);
            storage_metadata.move_all_tags(&moved_files)
        }
    }
}
