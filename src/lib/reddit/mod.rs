pub mod client;
pub mod operations;
pub mod structs;

pub static APP_USER_AGENT: &str = concat!(
    "linux:",
    env!("CARGO_PKG_NAME"),
    ":",
    env!("CARGO_PKG_VERSION"),
    " by /u/TSearR"
);
