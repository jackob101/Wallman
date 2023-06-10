mod cli;

#[macro_use]
extern crate simple_log;
extern crate core;

use std::env;

use clap::Parser;
use simple_log::LogConfigBuilder;

use wallman_lib::env_config::EnvConfig;
use wallman_lib::metadata::StorageMetadata;
use wallman_lib::wallheaven;

fn main() -> Result<(), String> {
    setup_logger()?;

    let cli = cli::Cli::parse();

    println!("{:#?}", cli);
    let config = EnvConfig::init();
    let mut storage_metadata = StorageMetadata::new(&config);

    cli::operation_handlers::handle_operation(cli, &config, &mut storage_metadata)?;

    if let Some(storage_metadata) = storage_metadata {
        storage_metadata.persist();
    }
    //
    // let client = wallheaven::client::wallman_client()
    //     .build()
    //     .map_err(|err| err.to_string())?;
    //
    // for i in 0..60 {
    //     let request = client.get("https://wallhaven.cc/api/v1/collections/TSear");
    //
    //     println!("Requesting {}", i);
    //
    //     if let Err(value) = wallheaven::client::limited_get(&client, request) {
    //         println!("{}", value);
    //         break;
    //     }
    // }
    Ok(())
}

fn setup_logger() -> Result<(), String> {
    let config = LogConfigBuilder::builder()
        .path(format!(
            "{}/.local/share/wallman.log",
            env::home_dir() //TODO: Maybe fix this someday.
                .expect("Failed to accuire home dir")
                .to_str()
                .expect("Faile to parse path to &str")
        ))
        .output_file()
        .build();

    simple_log::new(config)?;
    info!("Logger configured");

    Ok(())
}
