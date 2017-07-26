extern crate serde_json;

use std::io;
use std::path::Path;
use std::thread;
use std::fs;


const EXT_DOC: &'static [&str] = &["html", "adoc", "toml"];
const EXT_SCRIPTS: &'static [&str] = &["rs"];





// export class Item {
//   text: string;
// }

// export class Found {
//   key0: string;
//   key1: string;
//   item: Item;
// }
#[derive(Serialize, Deserialize, Debug)]
pub struct Found {
    pub key0: String,
    pub key1: String,
    pub item: Item,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct Item {
    pub text: String,
}



pub fn process_find(_: &str, ws_out: &::ws::Sender) -> Result<(), ::ws::Error> {
    let ws_out_copy = ws_out.clone();
    thread::spawn(move || exec_find(Path::new("."), &ws_out_copy));

    Ok(())
}


fn exec_find(dir: &Path, ws_out: &::ws::Sender) -> io::Result<()> {
    if dir.is_dir() {
        for entry in fs::read_dir(dir)? {
            let entry = entry?;
            let path = entry.path();
            if path.is_dir() {
                match exec_find(&path, ws_out) {
                    Ok(_) => {}
                    Err(e) => {
                        let _ = ::wss::send_log(&format!("{:?}", e), ws_out);
                    }
                }
            } else {
                use std::ffi::OsStr;
                let ext = path.extension()
                    .and_then(OsStr::to_str)
                    .unwrap_or("");

                let group = if EXT_DOC.contains(&ext) {
                    "DOC"
                } else if EXT_SCRIPTS.contains(&ext) {
                    "SCRIPTS"
                } else {
                    ""
                };

                if group.is_empty() == false {
                    let ofile_name = path.file_name()
                        .and_then(OsStr::to_str);
                    match ofile_name {
                        Some(file_name) => {
                            println!("Found: {}", file_name);
                            let data = ::wss::WSMsgData::Found(Found {
                                key0: group.to_owned(),
                                key1: ext.to_owned(),
                                item: Item { text: file_name.to_owned() },
                            });
                            let _ = ::wss::send_data(data, ws_out);
                        }
                        None => {
                            let _ = ::wss::send_log("Error reading file name", ws_out);
                        }
                    }
                }
            }
        }
    }
    Ok(())
}
