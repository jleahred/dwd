
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
    GetPluginFileExample,
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
    SimpleTxt {
        text: String,
    },
}


pub fn distribute_msg(msg: MsgIn, ws_out: &::ws::Sender) -> Result<(), ::ws::Error> {
    println!("Received: {:?}", msg);

    match msg {
        MsgIn::Find { text2find } => super::find::run(text2find, ws_out),
        MsgIn::GetPluginFileExample => super::wss::send_text(&::plugin::get_file_example(), ws_out),

    }
}
