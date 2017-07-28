extern crate serde_json;

use std::io;
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
pub struct Item {
    pub text: String,
    pub command: proto::MsgIn,
}



pub fn process_find(_: &str, ws_out: &::ws::Sender) -> Result<(), ::ws::Error> {
    let ws_out_copy = ws_out.clone();
    thread::spawn(move || exec_find(Path::new("."), &ws_out_copy));

    Ok(())
}


fn exec_find(dir: &Path, ws_out: &::ws::Sender) -> io::Result<()> {
    use std::ffi::OsStr;
    if dir.is_dir() {
        for entry in fs::read_dir(dir)? {
            let entry = entry?;
            let path = entry.path();
            let file_name_path = OsStr::to_str(path.as_os_str()).unwrap_or("???");
            // let file_name = path.file_name()
            //     .and_then(OsStr::to_str)
            //     .unwrap_or("???");
            if file_name_path.starts_with(".") && file_name_path.starts_with("./") == false {
                continue;
            }
            if path.is_dir() {
                println!("{:?}", file_name_path);
                match exec_find(&path, ws_out) {
                    Ok(_) => {}
                    Err(e) => {
                        let _ = super::wss::send_log(&format!("{:?}", e), ws_out);
                    }
                }
            } else {
                let ext = path.extension()
                    .and_then(OsStr::to_str)
                    .unwrap_or("");
                match ext {
                    "html" => {
                        let data = proto::MsgOut::Found(Found {
                            key0: "DOC".to_owned(),
                            key1: ext.to_owned(),
                            item: Item {
                                text: file_name_path.to_owned(),
                                command: proto::MsgIn::Html { file: file_name_path.to_owned() },
                            },
                        });
                        let _ = super::wss::send_data(data, ws_out);
                    }
                    _ => (),
                };
            }
        }
    }
    Ok(())
}
