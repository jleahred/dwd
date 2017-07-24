extern crate serde_json;

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
    thread::spawn(move || {
        exec_find("./", &ws_out_copy);
        //     let _ = ::wss::send_data(::wss::WSMsgData::Found(Found {
        //                                  key0: "key0".to_owned(),
        //                                  key1: "key1".to_owned(),
        //                                  val: vec!["aaaaaaaaaaaa".to_owned(), "bbbbbbbbbbb".to_owned()],
        //                              }),
        //                              &ws_out_copy);
        //     thread::sleep(Duration::from_millis(1000));
        //     let _ = ::wss::send_data(::wss::WSMsgData::Found(Found {
        //                                  key0: "key00".to_owned(),
        //                                  key1: "key11".to_owned(),
        //                                  val: vec!["aaaaaaaaaaaa".to_owned(), "bbbbbbbbbbb".to_owned()],
        //                              }),
        //                              &ws_out_copy);
    });

    Ok(())
}


fn exec_find(dir: &str, ws_out: &::ws::Sender) {
    match fs::read_dir(dir) {
        Ok(files) => {
            for path in files {
                let file_name = format!("{}", path.unwrap().path().display());
                println!("Name: {}", file_name);

                let data = ::wss::WSMsgData::Found(Found {
                    key0: file_name,
                    key1: "key1".to_owned(),
                    val: vec!["aaaaaaaaaaaa".to_owned(), "bbbbbbbbbbb".to_owned()],
                });
                let _ = ::wss::send_data(data, ws_out);
            }
        }
        Err(error) => {
            let _ = ::wss::send_log(&format!("{:?}", error), ws_out);
        }
    }
}