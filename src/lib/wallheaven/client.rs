use std::{thread, time::Duration};

use log::error;
use reqwest::{
    blocking::{self, Client, ClientBuilder, RequestBuilder, Response},
    StatusCode,
};

const USER_AGENT: &str = "Wallman/pietrzyk.jakub001@gmail.com";

pub fn wallman_client() -> blocking::ClientBuilder {
    ClientBuilder::new().user_agent(USER_AGENT)
}

pub fn limited_get(client: &Client, request: RequestBuilder) -> Result<Response, String> {
    let request = request.build().map_err(|err| err.to_string())?;

    loop {
        let response = client.execute(
            request
                .try_clone()
                .ok_or("Failed to copy request".to_string())?,
        );

        match response {
            Ok(value) => {
                let status = value.status();

                if status == StatusCode::TOO_MANY_REQUESTS {
                    let retry_after_header_value = value
                        .headers()
                        .get("retry-after")
                        .expect("API returned 429 without 'retry-after' header");

                    let retry_after_str = retry_after_header_value
                        .to_str()
                        .map_err(|err| err.to_string())?;

                    let retry_after: u64 = retry_after_str
                        .parse::<u64>()
                        .map_err(|err| err.to_string())?;

                    println!("Reached rate limit. Waiting: {}", retry_after);

                    thread::sleep(Duration::from_secs(retry_after));

                    continue;
                }

                return Ok(value);
            }
            Err(err) => {
                error!("Request failed: {:?}", err);
                return Err(err.to_string());
            }
        }
    }
}
