use std::{thread, time::Duration};

use log::debug;
use reqwest::{
    blocking::{Client, Response},
    StatusCode,
};

use super::{structs::Authorization, APP_USER_AGENT};

pub struct ClockedClient {
    client: Client,
    x_ratelimit_headers: Option<RatelimitHeaders>,
}

struct RatelimitHeaders {
    x_ratelimit_remaining: u32,
    x_ratelimit_reset: u32,
}

impl ClockedClient {
    pub fn new() -> ClockedClient {
        ClockedClient {
            client: Client::builder()
                .user_agent(APP_USER_AGENT)
                .build()
                .expect("No idea how this can fail"),
            x_ratelimit_headers: None,
        }
    }

    pub fn get_authorized<T>(
        &mut self,
        url: String,
        authorization: &Authorization,
    ) -> Result<T, String>
    where
        T: serde::de::DeserializeOwned,
    {
        self.block_if_requests_exceeds_limit();

        let request_result = self
            .client
            .get(url)
            .header(
                "authorization",
                format!(
                    "{} {}",
                    authorization.token_type, authorization.access_token
                ),
            )
            .send();

        debug!("{:?}", request_result);

        let response = request_result.map_err(|err| err.to_string())?;

        if let Some(headers) = ClockedClient::extract_ratelimit_headers(&response) {
            self.x_ratelimit_headers = Some(headers);
        }

        let response_body = response.text().map_err(|err| err.to_string())?;

        let parsed_response_body =
            serde_json::from_str(&response_body).map_err(|err| err.to_string())?;

        Ok(parsed_response_body)
    }

    pub fn get<T>(&self, url: &String) -> Result<T, String>
    where
        T: serde::de::DeserializeOwned,
    {
        let request_result = self.client.get(url).send();

        debug!("{:?}", request_result);

        let response = request_result.map_err(|err| err.to_string())?;

        let response_body = response.text().map_err(|err| err.to_string())?;

        let parsed_response_body =
            serde_json::from_str(&response_body).map_err(|err| err.to_string())?;

        Ok(parsed_response_body)
    }

    fn extract_ratelimit_headers(response: &Response) -> Option<RatelimitHeaders> {
        if response.status() != StatusCode::OK {
            return None;
        }

        let headers = response.headers();

        let x_ratelimit_remaining = headers.get("X-Ratelimit-Remaining");
        let x_ratelimit_reset = headers.get("X-Ratelimit-Reset");

        if x_ratelimit_remaining.is_none() || x_ratelimit_reset.is_none() {
            return None;
        }

        let x_ratelimit_remaining = x_ratelimit_remaining
            .unwrap()
            .to_str()
            .expect("X-Ratelimit-remaining -> contained invalid value")
            .parse::<f32>()
            .expect("X-Ratelimit-remaining is not an u32")
            as u32;
        let x_ratelimit_reset = x_ratelimit_reset
            .unwrap()
            .to_str()
            .expect("X-Ratelimit-reset -> contained invalid value")
            .parse::<u32>()
            .expect("X-Ratelimit-reset is not an u32");

        Some(RatelimitHeaders {
            x_ratelimit_reset,
            x_ratelimit_remaining,
        })
    }

    fn block_if_requests_exceeds_limit(&mut self) {
        if self.x_ratelimit_headers.is_none() {
            return;
        }

        let x_ratelimit_headers = self.x_ratelimit_headers.as_ref().unwrap();

        if x_ratelimit_headers.x_ratelimit_remaining > 0 {
            return;
        }

        println!(
            "Reached request threshold. Waiting {}s for another request",
            x_ratelimit_headers.x_ratelimit_reset
        );

        thread::sleep(Duration::from_secs(
            x_ratelimit_headers.x_ratelimit_reset as u64,
        ));

        self.x_ratelimit_headers = None;
    }
}

impl Default for ClockedClient {
    fn default() -> Self {
        ClockedClient::new()
    }
}
