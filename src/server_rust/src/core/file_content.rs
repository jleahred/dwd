extern crate iron;


pub fn get_static(file_name: &str) -> Option<&[u8]> {
    let fname = match file_name == "" {
        true => "index.html".to_owned(),
        false => file_name.to_owned(),
    };

    if let Some(content) = super::http_static2::get(&fname) {
        Some(content)
    } else {
        None
    }
}

pub fn get_content_from_disk(file_name: &str) -> Option<Vec<u8>> {
    use std::fs::File;
    use std::io::prelude::*;

    let mut f = File::open(file_name).unwrap();
    let mut buffer = Vec::new();

    f.read_to_end(&mut buffer).unwrap();
    if buffer.len() > 0 {
        Some(buffer)
    } else {
        None
    }
}

pub fn ctype(file_name: &str) -> iron::headers::ContentType {
    use std::path::Path;
    use std::ffi::OsStr;
    use iron::mime::{Mime, TopLevel, SubLevel};
    use iron::headers::ContentType;

    let path = Path::new(file_name);
    let result = match path.extension().and_then(OsStr::to_str) {
        Some("html") => ContentType(Mime(TopLevel::Text, SubLevel::Html, vec![])),
        Some("js") => ContentType(Mime(TopLevel::Application, SubLevel::Javascript, vec![])),
        Some("css") => ContentType(Mime(TopLevel::Text, SubLevel::Css, vec![])),
        Some("png") => ContentType(Mime(TopLevel::Image, SubLevel::Png, vec![])),
        Some("ico") => {
            ContentType(Mime(TopLevel::Image, SubLevel::Ext("x-ico".to_owned()), vec![]))
        }

        Some("txt") => ContentType(Mime(TopLevel::Text, SubLevel::Plain, vec![])),
        _ => ContentType(Mime(TopLevel::Text, SubLevel::Plain, vec![])),
    };
    result
}
