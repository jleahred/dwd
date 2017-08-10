extern crate serde;
extern crate serde_json;


#[derive(Serialize, Deserialize, Debug)]
struct ScriptInfo {
    command: String,
    params: Vec<Param>,
}


#[derive(Serialize, Deserialize, Debug)]
enum Param {
    Text(String),
    Number(i32),
    Date {
        year: i32,
        month: i32,
        day: i32,
    },
}

pub fn get_file_example() -> String {
    serde_json::to_string_pretty(&ScriptInfo {
        command: "cargo run $PARAM1 $PARAM2".to_owned(),
        params: vec![Param::Text("param_string".to_owned())],
    }).unwrap_or("error generating plugin file example".to_owned())
}