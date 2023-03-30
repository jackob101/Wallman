#[macro_use]
extern crate simple_log;

use clap::{arg, ArgMatches, Command};
use simple_log::LogConfigBuilder;

use wallman_lib::{delete, download, organize};

fn cli() -> Command {
    Command::new("wallman")
        .about("Wallpapers manager")
        .arg_required_else_help(true)
        .subcommand(
            Command::new("download")
                .about("Download image from URL")
                .arg(arg!(<URL> "URL to image"))
                .arg_required_else_help(true),
        )
        .subcommand(
            Command::new("delete")
                .about("Remove image with passed ID")
                .arg(arg!(<ID> "Image ID. Images are stored like <ID>.<image format>"))
                .arg_required_else_help(true),
        )
        .subcommand(Command::new("organise").about("Organise image storage"))
}

fn main() -> Result<(), String> {
    setup_logger()?;

    let matches = cli().get_matches();

    match matches.subcommand() {
        Some(("download", sub_matches)) => handle_download_operation(sub_matches),
        Some(("delete", sub_matches)) => handle_delete_operation(sub_matches),
        Some(("organise", _)) => organize(),
        None => {}
        _ => unreachable!(),
    }

    Ok(())
}

fn handle_download_operation(args: &ArgMatches) {
    let url = args.get_one::<String>("URL").expect("required");
    download(url);
}

fn handle_delete_operation(args: &ArgMatches) {
    let id = args.get_one::<u32>("ID").expect("required");
    delete(*id);
}

fn setup_logger() -> Result<(), String> {
    let config = LogConfigBuilder::builder().output_console().build();

    simple_log::new(config)?;
    info!("Logger configured");

    Ok(())
}
