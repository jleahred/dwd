extern crate serde_json;

use std::io;
use std::path::Path;
use std::thread;
use std::fs;




// use self::serde_json::Error;

// export class Found {
//   key0: string;
//   key1: string;
//   val: string[];
// }
#[derive(Serialize, Deserialize, Debug)]
pub struct Found {
    pub key0: String,
    pub key1: String,
    pub val: Vec<String>,
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
                if ::EXT_FILES.contains(&ext) {
                    let ofile_name = path.file_name()
                        .and_then(OsStr::to_str);
                    match ofile_name {
                        Some(file_name) => {
                            println!("Found: {}", file_name);
                            let data = ::wss::WSMsgData::Found(Found {
                                key0: "docs".to_owned(),
                                key1: ext.to_owned(),
                                val: vec![file_name.to_owned()],
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
