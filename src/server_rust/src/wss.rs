extern crate serde;
extern crate serde_json;



#[derive(Serialize, Deserialize, Debug)]
// #[serde(tag = "type", content = "data")]
// #[serde(untagged)]
#[serde(tag = "type")]
pub enum WSMsgData {
    Log { log_line: String },
    Find { text2find: String },
    Found(::find::Found),
}



fn distribute_msg(msg: WSMsgData, ws_out: &::ws::Sender) -> Result<(), ::ws::Error> {
    println!("Received: {:?}", msg);

    match msg {
        WSMsgData::Find { text2find: data } => ::find::process_find(&data, ws_out),
        data => {
            send_data(msg_log(&format!("type {:?} not supported  or incorrect fields for this \
                                        type",
                                       data)),
                      ws_out)
        }
    }
}





pub fn process_ws_msg(msg: ::ws::Message, ws_out: &::ws::Sender) -> Result<(), ::ws::Error> {
    println!("processing: {:?}", msg);

    match msg.as_text() {
        Ok(msg_txt) => {
            match serde_json::from_str::<WSMsgData>(msg_txt) {
                Ok(wsmsg) => distribute_msg(wsmsg, ws_out),
                Err(e) => send_data(msg_log(&format!("{:?}", e)), ws_out),
            }
        }
        Err(e) => send_data(msg_log(&format!("{:?}", e)), ws_out),
    }
}




pub fn send_data(data: WSMsgData, ws_out: &::ws::Sender) -> Result<(), ::ws::Error> {
    let msg_json = serde_json::to_string(&data)
        // .unwrap();
    .unwrap_or("Internal error creating output message!!!".to_owned());
    ws_out.send(msg_json)
}

fn msg_log(info: &str) -> ::wss::WSMsgData {
    println!("sending log: {:?}", info);
    WSMsgData::Log { log_line: info.to_owned() }
}