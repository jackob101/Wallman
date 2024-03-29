use clap::{Parser, Subcommand};
use uuid::Uuid;

pub mod operation_handlers;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
pub struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand, Debug)]
pub enum Commands {
    #[command(subcommand)]
    Index(IndexOperation),
    #[command(subcommand)]
    Reddit(RedditOperation),
    #[command(subcommand)]
    Wallheaven(WallheavenOperation),
    #[command(subcommand)]
    Image(ImageOperation),
    Query {
        collection: String,
        tags: Vec<String>,
    },
}

#[derive(Subcommand, Debug)]
pub enum ImageOperation {
    Download {
        collection: String,
        url: String,
        #[arg(short, long, num_args = 1..)]
        tags: Option<Vec<String>>,
    },
    Delete {
        collection: String,
        ids: Vec<Uuid>,
    },
    #[command(subcommand)]
    Tag(ImageOperationTag),
}

#[derive(Subcommand, Debug)]
pub enum ImageOperationTag {
    /// Add [TAG] to file with <ID>
    Add {
        collection: String,
        /// File ID
        id: Uuid,
        /// One or more tag names separated by space
        tags: Vec<String>,
    },
    /// Delete assigned [TAG] from file with <ID>
    Delete {
        collection: String,
        /// File ID
        id: Uuid,
        /// One or more tag names separated by space
        tags: Vec<String>,
    },
    /// Remove all tags from file with ID
    Clear {
        collection: String,
        /// File ID
        id: Uuid,
    },
}

#[derive(Subcommand, Debug)]
pub enum IndexOperation {
    ///Create file for string metadata about storage
    Init { collection: String },
    ///Try to fix incorrect data inside the metadata file
    Fix { collection: String },
    ///Downloads missing images from index
    Restore { collection: String },
}

#[derive(Subcommand, Debug)]
pub enum RedditOperation {
    Authorize,
    AcceptRedirect {
        uri: String,
    },
    Sync {
        #[arg(short = 'l', long = "limit")]
        upvoted_posts_fetch_limit: Option<u8>,
    },
}

#[derive(Subcommand, Debug)]
pub enum WallheavenOperation {
    Sync,
}
