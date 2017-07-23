extern crate serde_json;


// use self::serde_json::Error;

// export class Found {
//   key0: string;
//   key1: string;
//   val: string[];
// }
#[derive(Serialize, Deserialize)]
pub struct Found {
    pub key0: String,
    pub key1: String,
    pub val: Vec<String>,
}


pub fn process_find(_: &str, ws_sender: &::ws::Sender) -> Result<(), ::ws::Error> {
    let data_txt = serde_json::to_string(&Found {
            key0: "key0".to_owned(),
            key1: "key1".to_owned(),
            val: vec!["asfsadf".to_owned(), "sadfasdfasdf".to_owned()],
        })
        .unwrap_or("Internal error creating output message!!!".to_owned());
    ws_sender.send(data_txt)
}
