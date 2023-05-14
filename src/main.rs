mod cli;
mod commands;

#[macro_use]
extern crate simple_log;
extern crate core;

use simple_log::LogConfigBuilder;

use wallman_lib::env_config::EnvConfig;
use wallman_lib::metadata::StorageMetadata;

fn main() -> Result<(), String> {
    setup_logger()?;
    let env_config = EnvConfig::init();
    let mut storage_metadata = StorageMetadata::new(&env_config);

    let matches = commands::generate_commands().get_matches();

    cli::operation_handlers::handle(&matches, &env_config, &mut storage_metadata)?;

    storage_metadata.persist();

    Ok(())
}

fn setup_logger() -> Result<(), String> {
    let config = LogConfigBuilder::builder().output_console().build();

    simple_log::new(config)?;
    info!("Logger configured");

    Ok(())
}
