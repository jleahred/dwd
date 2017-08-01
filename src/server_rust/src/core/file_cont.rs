extern crate iron;


pub fn get(file_name: &str) -> &[u8] {
    #[cfg(debug_assertions)]
    use core::http_static_fake as http_static;
    #[cfg(not(debug_assertions))]
    use core::http_static;

    let fname = match file_name == "" {
        true => "http_static/index.html".to_owned(),
        false => format!("http_static/{}", file_name),
    };

    match http_static::get(&fname) {
        Ok(content) => content,
        Err(_) => &[] as &[u8],
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
    println!("{}", result);
    result
}