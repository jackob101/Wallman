use std::{borrow::Cow, collections::HashMap, fs, str::FromStr};

use clap::ArgMatches;
use log::{debug, error, info};

use crate::env_config::EnvConfig;

static APP_USER_AGENT: &str = concat!(
    "linux:",
    env!("CARGO_PKG_NAME"),
    ":",
    env!("CARGO_PKG_VERSION"),
    " by /u/TSearR"
);

#[derive(Debug, serde::Serialize, serde::Deserialize)]
struct Authorization {
    access_token: String,
    token_type: String,
    expires_in: u32,
    refresh_token: String,
    scope: String,
}

pub fn sync() {}

pub fn ask_for_grants() {
    let client_id = env!("CLIENT_ID");
    let url = format!( "https://www.reddit.com/api/v1/authorize?client_id={}&response_type=code&state=testing&redirect_uri=wallman%3A%2F%2Fredirect&duration=permanent&scope=history", client_id);
    open::that(url).expect("Failed to open URL. Make sure that you have default browser");
}

pub fn handle_authorization_redirect(
    sub_matches: &ArgMatches,
    config: &EnvConfig,
) -> Result<(), String> {
    info!("User gave access to account historical data");

    let uri = sub_matches
        .get_one::<String>("URI")
        .expect("URI is required, it must be present");

    let uri_parsing_result = parse_redirect_uri(uri);

    if let Err(err) = uri_parsing_result {
        error!("{}", err);
        return Err(err);
    }

    let (state, code) = uri_parsing_result.unwrap();

    let request_client = reqwest::blocking::ClientBuilder::new()
        .user_agent(APP_USER_AGENT)
        .build()
        .expect("How can this even fail?");

    let mut post_data = HashMap::new();
    post_data.insert("grant_type", "authorization_code");
    post_data.insert("code", &code);
    post_data.insert("redirect_uri", "wallman://redirect");

    let token_response = request_client
        .post("https://www.reddit.com/api/v1/access_token")
        .form(&post_data)
        .basic_auth("EBWOFdkZw0cT4rzwsa3Qkg", None::<String>)
        .send();

    if let Err(err) = token_response {
        error!("Failed to retrieve access token {:?}", err);
        return Err("Failed to retrieve access token".to_owned());
    }

    let response_body = token_response
        .unwrap()
        .text()
        .expect("Failed to retrieve body from response");

    info!("Received token {:?}", &response_body);

    let parsed_response: Result<Authorization, serde_json::Error> =
        serde_json::from_str(&response_body);

    if let Err(err) = parsed_response {
        error!("{:?}", err);
        return Err("Failed to parse access_token response".to_owned());
    }

    let parsed_response = parsed_response.unwrap();

    info!("Successfully parsed access_token response");

    let file = fs::OpenOptions::new()
        .write(true)
        .create(true)
        .truncate(true)
        .open(config.storage_directory.join(env!("AUTHORIZATION_FILE")))
        .expect("Failed to open/create file");

    info!("Saving authorization informations");

    let write_result = serde_json::to_writer(&file, &parsed_response);

    match write_result {
        Ok(_) => {
            info!("Saved authorization");
            Ok(())
        }
        Err(err) => {
            error!("{:?}", err);
            Err(err.to_string())
        }
    }
}

fn parse_redirect_uri(uri: &str) -> Result<(String, String), String> {
    let uri = reqwest::Url::from_str(uri).expect("Failed to parse url");

    let mut state: Option<String> = None;
    let mut code: Option<String> = None;

    for (key, value) in uri.query_pairs() {
        match key {
            Cow::Borrowed("code") => code = Some(value.into_owned()),
            Cow::Borrowed("state") => state = Some(value.into_owned()),
            Cow::Borrowed("error") => {
                error!("Failed to authorize {}", value.into_owned());
                return Err("Authorization returned error".to_owned());
            }
            _ => unreachable!("Reddit API returns only these query params: code, state, error"),
        }
    }

    if state.is_none() || code.is_none() {
        return Err("Authorization response doesn't have 'state'/'code'".to_string());
    };

    Ok((state.unwrap(), code.unwrap()))
}
