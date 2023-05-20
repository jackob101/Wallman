mod cli;

#[macro_use]
extern crate simple_log;
extern crate core;

use std::env;

use simple_log::LogConfigBuilder;

use wallman_lib::env_config::EnvConfig;
use wallman_lib::metadata::StorageMetadata;

fn main() -> Result<(), String> {
    setup_logger()?;
    let env_config = EnvConfig::init();
    let mut storage_metadata = StorageMetadata::new(&env_config);

    let matches = cli::commands::generate_commands().get_matches();

    cli::operation_handlers::handle(&matches, &env_config, &mut storage_metadata)?;

    storage_metadata.persist();

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
