
// -----------------------------------------------------
//  I N
// -----------------------------------------------------

#[derive(Serialize, Deserialize, Debug)]
// #[serde(tag = "type", content = "data")]
// #[serde(untagged)]
#[serde(tag = "type")]
pub enum MsgIn {
    Find {
        text2find: String,
    },
    Html {
        file: String,
    },
}


// -----------------------------------------------------
//  O U T
// -----------------------------------------------------

#[derive(Serialize, Deserialize, Debug)]
#[serde(tag = "type")]
pub enum MsgOut {
    Log {
        log_line: String,
    },
    Found(super::find::Found),
    Html {
        data: String,
    },
}


pub fn distribute_msg(msg: MsgIn, ws_out: &::ws::Sender) -> Result<(), ::ws::Error> {
    println!("Received: {:?}", msg);

    match msg {
        MsgIn::Find { text2find } => super::find::process_find(&text2find, ws_out),
        MsgIn::Html { file } => super::send_file_cont::send(&file, ws_out),
    }
}
