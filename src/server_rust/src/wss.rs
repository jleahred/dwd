extern crate serde;
extern crate serde_json;


#[derive(Serialize, Deserialize, Debug, Clone, Copy)]
pub enum Topic {
    Log,
    Find,
}

// #[derive(Serialize, Deserialize, Debug, Clone, Copy)]
// pub enum MType {
//     Log,
//     Find,
//     Found,
// }

#[derive(Serialize, Deserialize, Debug)]
// #[serde(tag = "type", content = "data")]
// #[serde(untagged)]
#[serde(tag = "type")]
pub enum WSMsgData {
    Log {
        log_line: String,
    },
    Find {
        text2find: String,
    },
    Found(::find::Found),
}

// #[derive(Serialize, Deserialize, Debug)]
// pub struct WM<T> {
//     pub topic: Topic,
//     pub data:
// }


#[derive(Serialize, Deserialize, Debug)]
pub struct WSMsg {
    pub topic: Topic,
    // pub mtype: MType,
    // #[serde(flatten, tag = "type")]
    pub data: WSMsgData,
}


fn distribute_msg(msg: WSMsg, ws_sender: &::ws::Sender) -> Result<(), ::ws::Error> {
    println!("Received: {:?}", msg);
    match (msg.topic, msg.data) {
        (Topic::Find, WSMsgData::Find { text2find: data }) => {
            ::find::process_find(&data, ws_sender)
        }
        (topic, data) => {
            send_log(&format!("topic type {:?} not supported  or incorrect data {:?}",
                              topic,
                              data),
                     ws_sender)
        }
    }
}





pub fn process_ws_msg(msg: ::ws::Message, ws_sender: &::ws::Sender) -> Result<(), ::ws::Error> {
    println!("processing: {:?}", msg);
    match msg.as_text() {
        Ok(msg_txt) => {
            match serde_json::from_str::<WSMsg>(msg_txt) {
                Ok(wsmsg) => distribute_msg(wsmsg, ws_sender),
                Err(e) => send_log(&format!("{:?}", e), ws_sender),
            }
        }
        Err(e) => send_log(&format!("{:?}", e), ws_sender),
    }
}




pub fn send_data(topic: Topic,
                 data: WSMsgData,
                 ws_sender: &::ws::Sender)
                 -> Result<(), ::ws::Error> {
    let msg_json = serde_json::to_string(&WSMsg {
            topic: topic,
            data: data,
        })
        .unwrap();
    // .unwrap_or("Internal error creating output message!!!".to_owned());
    ws_sender.send(msg_json)
}

fn send_log(info: &str, ws_sender: &::ws::Sender) -> Result<(), ::ws::Error> {
    println!("sending log: {:?}", info);
    send_data(Topic::Log, WSMsgData::Log{ log_line: info.to_owned()}, ws_sender)
}