extern crate serde;
extern crate serde_json;


#[derive(Serialize, Deserialize, Debug, Clone, Copy)]
pub enum Topic {
    Log,
    Find,
}

#[derive(Serialize, Deserialize, Debug, Clone, Copy)]
pub enum MType {
    Log,
    Find,
    Found,
}


#[derive(Serialize, Deserialize)]
pub struct WSMsg {
    pub topic: Topic,
    pub mtype: MType,
    pub data: String,
}


fn distribute_msg(msg: &WSMsg, ws_sender: &::ws::Sender) -> Result<(), ::ws::Error> {
    match (msg.topic, msg.mtype) {
        (Topic::Find, MType::Find) => ::find::process_find(&msg.data, ws_sender),
        (_, _) => {
            send_log(&format!("topic type not supported  {:?}/{:?}", msg.topic, msg.mtype),
                     ws_sender)
        }
    }
}





pub fn process_ws_msg(msg: ::ws::Message, ws_sender: &::ws::Sender) -> Result<(), ::ws::Error> {
    match msg.as_text() {
        Ok(msg_txt) => {
            match serde_json::from_str::<WSMsg>(msg_txt) {
                Ok(wsmsg) => distribute_msg(&wsmsg, ws_sender),
                Err(e) => send_log(&format!("{:?}", e), ws_sender),
            }
        }
        Err(e) => send_log(&format!("{:?}", e), ws_sender),
    }
}




pub fn send_data(topic: Topic,
                 mtype: MType,
                 data: &str,
                 ws_sender: &::ws::Sender)
                 -> Result<(), ::ws::Error> {
    let data_txt = serde_json::to_string(&WSMsg {
            topic: topic,
            mtype: mtype,
            data: format!("{:?}", data),
        })
        .unwrap_or("Internal error creating output message!!!".to_owned());
    ws_sender.send(data_txt)
}

fn send_log(data: &str, ws_sender: &::ws::Sender) -> Result<(), ::ws::Error> {
    send_data(Topic::Log, MType::Log, data, ws_sender)
}