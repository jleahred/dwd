extern crate serde_json;

use std::path::Path;
use std::thread;
use std::fs;

use super::proto;





#[derive(Serialize, Deserialize, Debug)]
pub struct Found {
    pub key0: String,
    pub key1: String,
    pub item: Item,
}

#[derive(Serialize, Deserialize, Debug)]
// #[serde(tag = "type")]
pub enum Item {
    Command(String),
    Link(String),
}


struct FindStatus {
    max_items: i32,
}
const MAX_ITEMS: i32 = 100;


pub fn process_find(_: &str, ws_out: &::ws::Sender) -> Result<(), ::ws::Error> {
    let ws_out_copy = ws_out.clone();
    thread::spawn(move || {
        match exec_find(Path::new("."),
                        &ws_out_copy,
                        &mut FindStatus { max_items: MAX_ITEMS }) {
            Ok(_) => (),
            Err(e) => {
                let _ = super::wss::send_log(&format!("{:?}", e), &ws_out_copy);
            }
        };
    });
    Ok(())
}


fn exec_find(dir: &Path, ws_out: &::ws::Sender, status: &mut FindStatus) -> Result<(), String> {
    use std::ffi::OsStr;
    if dir.is_dir() {
        if let Some(file_name) = dir.file_name().and_then(|f| f.to_str()) {
            if file_name.starts_with(".") {
                return Ok(());
            }
        }
        // thread::sleep(time::Duration::from_millis(5));
        for entry in fs::read_dir(dir).map_err(|e| e.to_string())? {
            let entry = entry.map_err(|e| e.to_string())?;
            let path = entry.path();
            let file_name_path = OsStr::to_str(path.as_os_str()).unwrap_or("???");
            if path.is_dir() {
                exec_find(&path, ws_out, status)?;
            } else {
                let ext = path.extension()
                    .and_then(OsStr::to_str)
                    .unwrap_or("");
                let data = match ext {
                    "html" => {
                        Some(proto::MsgOut::Found(Found {
                            key0: "DOC".to_owned(),
                            key1: ext.to_owned(),
                            item: Item::Link(file_name_path.to_owned()),
                        }))
                    }
                    _ => None,
                };
                send_item(data, ws_out, status)?;
            }
        }
    }
    Ok(())
}


fn send_item(data: Option<proto::MsgOut>,
             ws_out: &::ws::Sender,
             status: &mut FindStatus)
             -> Result<(), String> {
    if status.max_items == 0 {
        return Err("too many items".to_owned());
    }

    match data {
        Some(data) => {
            status.max_items -= 1;
            super::wss::send_data(data, ws_out).map_err(|e| e.to_string())
        }
        None => Ok(()),
    }
}