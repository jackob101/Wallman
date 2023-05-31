use clap::{Parser, Subcommand};

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
    Image(ImageOperation),
    Query {
        tags: Vec<String>,
    },
    /// Sort data inside storage directory
    Organise,
}

#[derive(Subcommand, Debug)]
pub enum ImageOperation {
    Download {
        url: String,
        #[arg(short, long, num_args = 1..)]
        tags: Option<Vec<String>>,
    },
    Delete {
        ids: Vec<u32>,
    },
    #[command(subcommand)]
    Tag(ImageOperationTag),
}

#[derive(Subcommand, Debug)]
pub enum ImageOperationTag {
    /// Add [TAG] to file with <ID>
    Add {
        /// File ID
        id: u32,
        /// One or more tag names separated by space
        tags: Vec<String>,
    },
    /// Delete assigned [TAG] from file with <ID>
    Delete {
        /// File ID
        id: u32,
        /// One or more tag names separated by space
        tags: Vec<String>,
    },
    /// Remove all tags from file with ID
    Clear {
        /// File ID
        id: u32,
    },
}

#[derive(Subcommand, Debug)]
pub enum IndexOperation {
    ///Create file for string metadata about storage
    Init,
    ///Try to fix incorrect data inside the metadata file
    Fix,
}

#[derive(Subcommand, Debug)]
pub enum RedditOperation {
    Authorize,
    AcceptRedirect { uri: String },
    Sync,
}
