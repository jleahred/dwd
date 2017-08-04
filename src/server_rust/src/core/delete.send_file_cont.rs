use std::fs::File;
use std::io::prelude::*;

use super::wss;
use super::proto;


pub fn send(file_name: &str, ws_out: &::ws::Sender) -> Result<(), ::ws::Error> {
    let mut f = File::open(file_name).expect(&format!("file not found: {}", file_name));
    let mut contents = String::new();
    f.read_to_string(&mut contents).expect(&format!("reading file error: {}", file_name));

    println!("{}", contents);
    wss::send_data(proto::MsgOut::Html { data: contents }, ws_out)
}