use self::structs::CollectionsResponse;

mod client;
mod structs;

pub fn sync() -> Result<(), String> {
    let client = client::wallman_client()
        .build()
        .map_err(|err| err.to_string())?;

    let request_builder = client.get("https://wallhaven.cc/api/v1/collections/TSear");

    let collection_response = client::limited_get(&client, request_builder)?;

    let collection_response = collection_response
        .json::<CollectionsResponse>()
        .map_err(|err| err.to_string())?;

    println!("{:#?}", collection_response);

    Ok(())
}
