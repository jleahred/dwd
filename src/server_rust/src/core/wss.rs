extern crate serde;
extern crate serde_json;

use super::proto;






pub fn process_ws_msg(msg: ::ws::Message, ws_out: &::ws::Sender) -> Result<(), ::ws::Error> {
    println!("processing: {:?}", msg);

    match msg.as_text() {
        Ok(msg_txt) => {
            match serde_json::from_str::<self::proto::MsgIn>(msg_txt) {
                Ok(wsmsg) => proto::distribute_msg(wsmsg, ws_out),
                Err(e) => send_log(&format!("{:?}", e), ws_out),
            }
        }
        Err(e) => send_log(&format!("{:?}", e), ws_out),
    }
}




pub fn send_data(data: proto::MsgOut, ws_out: &::ws::Sender) -> Result<(), ::ws::Error> {
    let msg_json = serde_json::to_string(&data)
        .unwrap_or("Internal error creating output message!!!".to_owned());
    ws_out.send(msg_json)
}

fn msg_log(info: &str) -> proto::MsgOut {
    println!("sending log: {:?}", info);
    super::proto::MsgOut::Log { log_line: info.to_owned() }
}

pub fn send_log(log_line: &str, ws_out: &::ws::Sender) -> Result<(), ::ws::Error> {
    send_data(msg_log(log_line), ws_out)
}