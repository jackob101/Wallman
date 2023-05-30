use std::{
    borrow::Cow,
    collections::HashMap,
    fs::{self, File},
    io::BufReader,
    str::FromStr,
    vec,
};

use clap::ArgMatches;
use log::{debug, error, info};
use reqwest::blocking;

use crate::{
    env_config::EnvConfig,
    metadata::StorageMetadata,
    reddit::{client, structs::*, APP_USER_AGENT},
    storage, INDEX_NOT_INITIALIZED_ERROR,
};

pub fn sync(config: &EnvConfig, storage_metadata: &mut StorageMetadata) -> Result<(), String> {
    if storage_metadata.metadata.is_none() {
        return Err(INDEX_NOT_INITIALIZED_ERROR.to_owned());
    }
    let authorization = parse_authorization_file(config)?;
    let new_authorization = get_new_authorization_token(&authorization)?;

    let mut request_client = client::ClockedClient::new();

    let user_account_information_response = request_client.get_authorized::<UserResponse>(
        "https://oauth.reddit.com/api/v1/me".to_owned(),
        &new_authorization,
    );

    debug!("{:?}", user_account_information_response);

    let user_account_informations = match user_account_information_response {
        Ok(value) => value,
        Err(err) => {
            error!("{}", err);
            return Err("Failed to fetch user account informations".to_owned());
        }
    };

    debug!("Fetched username {}", user_account_informations.name);

    let upvoted_post_vec: Vec<T3Data> = {
        let mut upvoted_post_vec: Vec<T3Data> = vec![];

        let mut after: Option<String> = None;

        loop {
            let url = if after.is_none() {
                format!(
                    "https://oauth.reddit.com/user/{}/upvoted.json?limit=100",
                    user_account_informations.name
                )
            } else {
                format!(
                    "https://oauth.reddit.com/user/{}/upvoted.json?limit=100&after={}",
                    user_account_informations.name,
                    after.as_ref().unwrap()
                )
            };

            println!("Executing request: {}", url);

            let upvoted_posts =
                request_client.get_authorized::<UpvotedResponse>(url, &new_authorization);

            let upvoted_posts = match upvoted_posts {
                Ok(value) => value,
                Err(err) => {
                    error!("{}", err);
                    return Err("Failed to fetch upvoted posts".to_owned());
                }
            };

            upvoted_posts
                .data
                .children
                .into_iter()
                .for_each(|entry| upvoted_post_vec.push(entry.data));

            if upvoted_posts.data.after.is_none() {
                break;
            }
            after = upvoted_posts.data.after;
        }

        upvoted_post_vec
    };

    // I have no idea if this inner block to make
    // posts_data immutable is good idea. Another option
    // is to just overshadow it.
    let post_information_vec: Vec<PostInformations> = {
        let mut post_information_vec = vec![];
        for post_data in upvoted_post_vec.iter() {
            if !"wallpaper".eq(&post_data.subreddit) {
                continue;
            }
            if post_data.preview.is_none() {
                continue;
            }
            let post_image = post_data.preview.as_ref().unwrap().images.get(0);
            if post_image.is_none() {
                continue;
            }
            let image_url = &post_image.as_ref().unwrap().source.url;

            post_information_vec.push(PostInformations {
                permalink: post_data.permalink.to_string(),
                image_url: image_url.to_string().replace("&amp;", "&"),
            })
        }

        post_information_vec
    };

    storage::download_bulk(&post_information_vec, config, storage_metadata).expect(""); //TODO implement errors

    write_authorization_to_file(config, &new_authorization)
}

pub fn ask_user_for_grants_to_account(config: &EnvConfig) {
    let client_id = env!("CLIENT_ID");
    let state = uuid::Uuid::new_v4();
    let url = format!( "https://www.reddit.com/api/v1/authorize?client_id={}&response_type=code&state={}&redirect_uri=wallman%3A%2F%2Fredirect&duration=permanent&scope=history identity", client_id, state);
    open::that(url).expect("Failed to open URL. Make sure that you have default browser");

    let state_uuid_filename = config.storage_directory.join(env!("STATE_UUID_FILENAME"));
    fs::write(
        config.storage_directory.join(state_uuid_filename),
        state.to_string(),
    )
    .expect("Couldn't create/write to state file");
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

    let authorize_state =
        fs::read_to_string(config.storage_directory.join(env!("STATE_UUID_FILENAME")))
            .expect("Couldn't open state file");

    if !state.eq(&authorize_state) {
        error!("state from authorize request and response are not equal!");
        return Err("state from authorize request and response are not equal!".to_owned());
    }

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

    write_authorization_to_file(config, &parsed_response)
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

fn parse_authorization_file(config: &EnvConfig) -> Result<Authorization, String> {
    let authorization_file = File::open(
        config
            .storage_directory
            .join(env!("AUTHORIZATION_FILENAME")),
    );

    let authorization_file = match authorization_file {
        Ok(file) => file,
        Err(err) => {
            error!("{}", err);
            return Err("Failed to open authorization file".to_string());
        }
    };

    let buf_reader = BufReader::new(authorization_file);
    match serde_json::from_reader(buf_reader) {
        Ok(parsed_value) => Ok(parsed_value),
        Err(err) => {
            error!("{}", err);
            Err("Failed to parse authorization file".to_string())
        }
    }
}

fn get_new_authorization_token(authorization: &Authorization) -> Result<Authorization, String> {
    let mut request_data = HashMap::new();
    request_data.insert("grant_type", "refresh_token");
    request_data.insert("refresh_token", &authorization.refresh_token);

    let request_client = blocking::Client::builder()
        .user_agent(APP_USER_AGENT)
        .build()
        .expect("I have no idea how this could fail"); //TODO: read how this can fail

    let fresh_access_token_response = request_client
        .post("https://www.reddit.com/api/v1/access_token")
        .basic_auth(env!("CLIENT_ID"), None::<String>)
        .form(&request_data)
        .send();

    let token_response = match fresh_access_token_response {
        Ok(token_response) => token_response
            .text()
            .expect("Failed to get authorization response body"),
        Err(err) => {
            error!("{}", err);
            return Err("Failed to retrieve new access token".to_owned());
        }
    };

    debug!("Authorization response: {}", token_response);

    let new_authorization: Result<Authorization, serde_json::Error> =
        serde_json::from_str(&token_response);

    if let Err(err) = new_authorization {
        error!("{:?}", err);
        return Err("Failed to parse access_token response".to_owned());
    }

    let parsed_response = new_authorization.unwrap();

    info!("Successfully parsed access_token response");

    Ok(parsed_response)
}

fn write_authorization_to_file(
    config: &EnvConfig,
    authorization: &Authorization,
) -> Result<(), String> {
    let file = fs::OpenOptions::new()
        .write(true)
        .create(true)
        .truncate(true)
        .open(
            config
                .storage_directory
                .join(env!("AUTHORIZATION_FILENAME")),
        )
        .expect("Failed to open/create file");

    info!("Saving authorization informations");

    let write_result = serde_json::to_writer(&file, &authorization);

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
