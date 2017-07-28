extern crate serde;
extern crate serde_json;


#[derive(Serialize, Deserialize, Debug)]
// #[serde(tag = "type", content = "data")]
// #[serde(untagged)]
#[serde(tag = "type")]
pub enum MsgIn {
    Find { text2find: String },
    Html { file: String },
}

#[derive(Serialize, Deserialize, Debug)]
// #[serde(tag = "type", content = "data")]
// #[serde(untagged)]
#[serde(tag = "type")]
pub enum MsgOut {
    Log { log_line: String },
    Found(::find::Found),
    Html { data: String },
}



fn distribute_msg(msg: MsgIn, ws_out: &::ws::Sender) -> Result<(), ::ws::Error> {
    println!("Received: {:?}", msg);

    match msg {
        MsgIn::Find { text2find } => ::find::process_find(&text2find, ws_out),
        MsgIn::Html { file } => ::send_file_cont::send(&file, ws_out),
    }
}





pub fn process_ws_msg(msg: ::ws::Message, ws_out: &::ws::Sender) -> Result<(), ::ws::Error> {
    println!("processing: {:?}", msg);

    match msg.as_text() {
        Ok(msg_txt) => {
            match serde_json::from_str::<MsgIn>(msg_txt) {
                Ok(wsmsg) => distribute_msg(wsmsg, ws_out),
                Err(e) => send_log(&format!("{:?}", e), ws_out),
            }
        }
        Err(e) => send_log(&format!("{:?}", e), ws_out),
    }
}




pub fn send_data(data: MsgOut, ws_out: &::ws::Sender) -> Result<(), ::ws::Error> {
    let msg_json = serde_json::to_string(&data)
        .unwrap_or("Internal error creating output message!!!".to_owned());
    ws_out.send(msg_json)
}

fn msg_log(info: &str) -> ::wss::MsgOut {
    println!("sending log: {:?}", info);
    MsgOut::Log { log_line: info.to_owned() }
}

pub fn send_log(log_line: &str, ws_out: &::ws::Sender) -> Result<(), ::ws::Error> {
    send_data(msg_log(log_line), ws_out)
}