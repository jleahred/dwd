extern crate serde;
extern crate serde_json;

use std;
use super::proto;


use ws::{listen, Handler, Sender, Result, Message, Handshake, CloseCode, Error};

struct Server {
    out: Sender,
    count: std::rc::Rc<std::cell::Cell<u32>>,
}

impl Server {
    fn tot_conn(&self) -> String {
        format!("Total connections: {}", self.count.get())
    }
}

impl Handler for Server {
    fn on_open(&mut self, _: Handshake) -> Result<()> {
        self.count.set(self.count.get() + 1);
        println!("New connection. {}", self.tot_conn());
        Ok(())
    }

    fn on_message(&mut self, msg: Message) -> Result<()> {
        println!("Server got message '{}'. ", msg);
        process_ws_msg(msg, &self.out)
    }

    fn on_close(&mut self, code: CloseCode, reason: &str) {
        self.count.set(self.count.get() - 1);
        match code {
            CloseCode::Normal => {
                println!("The client is done with the connection. {}",
                         self.tot_conn())
            }
            CloseCode::Away => println!("Client leaving socket. {}", self.tot_conn()),
            CloseCode::Abnormal => {
                println!("Closing handshake failed! Unable to obtain closing status from client. \
                          {}",
                         self.tot_conn())
            }
            _ => {
                println!("The client encountered an error: {} {}",
                         reason,
                         self.tot_conn())
            }
        }
    }

    fn on_error(&mut self, err: Error) {
        println!("The server encountered an error: {:?}", err);
    }
}


pub fn run(ws_socket: &str) {
    println!("WS server running on {}", ws_socket);
    let count = std::rc::Rc::new(std::cell::Cell::new(0));
    let _ = listen(ws_socket, |out| {
        Server {
            out: out,
            count: count.clone(),
        }
    });
}




pub fn process_ws_msg(msg: ::ws::Message, ws_out: &::ws::Sender) -> Result<()> {
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




pub fn send_data(data: proto::MsgOut, ws_out: &::ws::Sender) -> Result<()> {
    println!("{:?}", &data);
    let msg_json = serde_json::to_string(&data)
        .unwrap_or("Internal error creating output message!!!".to_owned());
    ws_out.send(msg_json)
}

fn msg_log(info: &str) -> proto::MsgOut {
    println!("sending log: {:?}", info);
    super::proto::MsgOut::Log { log_line: info.to_owned() }
}

pub fn send_log(log_line: &str, ws_out: &::ws::Sender) -> Result<()> {
    send_data(msg_log(log_line), ws_out)
}

pub fn send_text(txt: &str, ws_out: &::ws::Sender) -> Result<()> {
    send_data(super::proto::MsgOut::SimpleTxt{ text: txt.to_owned()}, ws_out)
}