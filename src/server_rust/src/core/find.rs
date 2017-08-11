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


struct FindMutStatus {
    max_items: i32,
}
const MAX_ITEMS: i32 = 100;

#[derive(Debug, Default, Clone, Copy)]
struct FindStatus {
    // found_dir_name: bool,
}


#[derive(Default)]
struct FindRules {
    and: Vec<String>,
    not: Vec<String>,
}


pub fn run(str_rules: String, ws_out: &::ws::Sender) -> Result<(), ::ws::Error> {
    let ws_out_copy = ws_out.clone();
    thread::spawn(move || {
        match exec_find(
            Path::new("."),
            &get_find_rules(&str_rules),
            &ws_out_copy,
            Default::default(),
            &mut FindMutStatus {
                max_items: MAX_ITEMS,
            },
        ) {
            Ok(_) => (),
            Err(e) => {
                let _ = super::wss::send_log(&format!("{:?}", e), &ws_out_copy);
            }
        };
    });
    Ok(())
}


fn exec_find(
    dir: &Path,
    find_rules: &FindRules,
    ws_out: &::ws::Sender,
    status: FindStatus,
    mut_status: &mut FindMutStatus,
) -> Result<(), String> {
    use std::ffi::OsStr;

    fn get_dir_name(dir: &Path) -> Result<String, String> {
        if dir.is_dir() == false {
            return Err(format!("Expected dir, not file {}", dir.display()));
        }

        let dir_name = dir.file_name().and_then(|f| f.to_str()).unwrap_or(".");
        Ok(dir_name.to_owned())
    }

    let dir_name = get_dir_name(dir)?;
    match dir_name.starts_with(".") && dir_name != "." {
        true => return Ok(()),
        false => (),
    }

    // thread::sleep(time::Duration::from_millis(5));
    for entry in fs::read_dir(dir).map_err(|e| e.to_string())? {
        let entry_path = entry.map_err(|e| e.to_string())?.path();
        if entry_path.is_dir() {
            // let new_status = get_new_status_by_dir_name(&dir_name, status, find_rules);
            exec_find(&entry_path, find_rules, ws_out, status, mut_status)?;
        } else {
            let file_name_path = OsStr::to_str(entry_path.as_os_str()).ok_or(format!(
                "Error getting string from path {}",
                entry_path.display()
            ))?;
            let file_name = entry_path
                .file_name()
                .and_then(OsStr::to_str)
                .ok_or(format!(
                    "Error getting string from path {}",
                    entry_path.display()
                ))?;
            if file_name.starts_with(".") {
                continue;
            }
            let ext = entry_path.extension().and_then(OsStr::to_str);

            let data = process_file(file_name_path, ext, find_rules);
            send_item(data, ws_out, mut_status)?;
        }
    }
    Ok(())
}


fn process_file(
    file_name_path: &str,
    ext: Option<&str>,
    find_rules: &FindRules,
) -> Option<self::proto::MsgOut> {
    if match_dirfile_name(file_name_path, find_rules) {
        match ext {
            Some("html") => {
                Some(proto::MsgOut::Found(Found {
                    key0: "LINK".to_owned(),
                    key1: "html".to_owned(),
                    item: Item::Link(file_name_path.to_owned()),
                }))
            }
            Some("pdf") => {
                Some(proto::MsgOut::Found(Found {
                    key0: "LINK".to_owned(),
                    key1: "pdf".to_owned(),
                    item: Item::Link(file_name_path.to_owned()),
                }))
            }
            Some("adoc") => {
                Some(proto::MsgOut::Found(Found {
                    key0: "TEXT".to_owned(),
                    key1: "adoc".to_owned(),
                    item: Item::Link(file_name_path.to_owned()),
                }))
            }
            Some("dwd") => {
                Some(proto::MsgOut::Found(Found {
                    key0: "PLUGIN".to_owned(),
                    key1: "dwd".to_owned(),
                    item: Item::Command(file_name_path.to_owned()),
                }))
            }
            _ => None,
        }
    } else {
        None
    }
}



fn match_dirfile_name(dir_name: &str, find_rules: &FindRules) -> bool {
    for andr in find_rules.and.iter() {
        if dir_name.contains(andr) == false {
            return false;
        }
    }
    for notr in find_rules.not.iter() {
        if dir_name.contains(notr) == true {
            return false;
        }
    }
    true
}


#[test]
fn test_match_dirfile_name_and() {
    assert!(match_dirfile_name(
        "abcdefg",
        &FindRules {
            and: vec!["ab".to_owned()],
            not: vec![],
        }
    ));

    assert!(match_dirfile_name(
        "abcdefg",
        &FindRules {
            and: vec!["ab".to_owned(), "def".to_owned()],
            not: vec![],
        }
    ));

    assert!(match_dirfile_name(
        "abcdefg",
        &FindRules {
            and: vec!["ab".to_owned(), "g".to_owned(), "bcd".to_owned()],
            not: vec![],
        }
    ));

    assert!(!match_dirfile_name(
        "abcdefg",
        &FindRules {
            and: vec!["abg".to_owned()],
            not: vec![],
        }
    ));

    assert!(!match_dirfile_name(
        "abcdefg",
        &FindRules {
            and: vec!["ab".to_owned(), "z".to_owned()],
            not: vec![],
        }
    ));

    assert!(!match_dirfile_name(
        "abcdefg",
        &FindRules {
            and: vec!["ab".to_owned(), "g".to_owned(), "bd".to_owned()],
            not: vec![],
        }
    ));
}

#[test]
fn test_match_dirfile_name_not() {
    assert!(match_dirfile_name(
        "abcdefg",
        &FindRules {
            and: vec!["ab".to_owned()],
            not: vec!["zz".to_owned()],
        }
    ));

    assert!(match_dirfile_name(
        "abcdefg",
        &FindRules {
            and: vec!["ab".to_owned(), "def".to_owned()],
            not: vec!["abd".to_owned()],
        }
    ));

    assert!(match_dirfile_name(
        "abcdefg",
        &FindRules {
            and: vec!["ab".to_owned(), "g".to_owned(), "bcd".to_owned()],
            not: vec!["fag".to_owned(), "ed".to_owned()],
        }
    ));

    assert!(!match_dirfile_name(
        "abcdefg",
        &FindRules {
            and: vec!["a".to_owned()],
            not: vec!["ab".to_owned()],
        }
    ));

    assert!(!match_dirfile_name(
        "abcdefg",
        &FindRules {
            and: vec!["ab".to_owned(), "def".to_owned()],
            not: vec!["g".to_owned()],
        }
    ));

    assert!(!match_dirfile_name(
        "abcdefg",
        &FindRules {
            and: vec!["ab".to_owned(), "g".to_owned(), "bcd".to_owned()],
            not: vec!["z".to_owned(), "de".to_owned()],
        }
    ));
}


fn send_item(
    data: Option<proto::MsgOut>,
    ws_out: &::ws::Sender,
    status: &mut FindMutStatus,
) -> Result<(), String> {
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


fn get_find_rules(s: &str) -> FindRules {
    let mut find_rules = FindRules {
        and: vec![],
        not: vec![],
    };

    let tokens = split_string_and_spaces(s);
    for token in tokens {
        let (and_not, tk) = match token.starts_with("-") {
            true => (
                &mut find_rules.not,
                token.chars().skip(1).collect::<String>(),
            ),
            false => (&mut find_rules.and, token),
        };
        and_not.push(tk);
    }

    find_rules
}

#[test]
fn test_get_find_rules() {
    let result = get_find_rules("aaa \"-bbb cc\" d \"-  ee ff\"  \" gg g g  \"");
    let expected = FindRules {
        and: vec!["aaa".to_owned(), "d".to_owned(), " gg g g  ".to_owned()],
        not: vec!["bbb cc".to_owned(), "  ee ff".to_owned()],
    };
    assert_eq!(result.and, expected.and);
    assert_eq!(result.not, expected.not);
}


fn split_string_and_spaces(s: &str) -> Vec<String> {
    let mut inside_string = false;
    let mut result = vec![];
    let mut current_token = "".to_owned();

    let push_result = |ct: &mut String, rs: &mut Vec<_>| if ct != "" {
        rs.push(ct.clone());
        ct.clear();
    };

    for (_, c) in s.chars().enumerate() {
        match inside_string {
            true => {
                if c == '"' {
                    push_result(&mut current_token, &mut result);
                    inside_string = false;
                } else {
                    current_token.push(c);
                }
            }
            false => {
                if c == '"' {
                    push_result(&mut current_token, &mut result);
                    inside_string = true;
                } else if c == ' ' {
                    push_result(&mut current_token, &mut result);
                } else {
                    current_token.push(c);
                }
            }
        }
    }
    push_result(&mut current_token, &mut result);
    result
}

#[test]
fn test_split_spaces() {
    let result = split_string_and_spaces("aaa bbb cc d ee ff");
    assert_eq!(result, vec!["aaa", "bbb", "cc", "d", "ee", "ff"]);
}

#[test]
fn test_split_spaces_consecutive() {
    let result = split_string_and_spaces("  aaa  bbb   cc d    ee ff ");
    assert_eq!(result, vec!["aaa", "bbb", "cc", "d", "ee", "ff"]);
}

#[test]
fn test_split_spaces_and_strings() {
    let result = split_string_and_spaces("aaa \"bbb cc\" d \"  ee ff\"  \" gg g g  \"");
    assert_eq!(result, vec!["aaa", "bbb cc", "d", "  ee ff", " gg g g  "]);
}
