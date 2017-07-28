use super::wss;
use super::proto;


pub fn send(file_name: &str, ws_out: &::ws::Sender) -> Result<(), ::ws::Error>
{
    wss::send_data(proto::MsgOut::Html { data: file_name.to_owned() }, ws_out)
}