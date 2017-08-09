extern crate serde;
extern crate serde_json;


#[derive(Serialize, Deserialize, Debug)]
struct ScriptInfo {
    command: String,
    params: Vec<Param>,
}


#[derive(Serialize, Deserialize, Debug)]
enum Param {
    String(String),
    Number(i32),
    Date {
        year: i32,
        month: i32,
        day: i32,
    },
}

use std;
pub fn get_file_example() -> std::result::Result<String, String> {
    serde_json::to_string(&ScriptInfo {
        command: "cargo run $PARAM1 $PARAM2".to_owned(),
        params: vec![Param::String("param_string".to_owned())],
    }).map_err(|e| e.to_string())
}