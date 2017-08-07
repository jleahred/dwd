use iron;
use iron::prelude::*;


use std::error::Error;
use std::fmt;


pub fn run(http_socket: &str) {
    println!("http server running on {}", http_socket);
    let _ = Iron::new(|req: &mut Request| get_response(req)).http(http_socket);
}



#[derive(Debug)]
pub struct NoFile;

impl Error for NoFile {
    fn description(&self) -> &str {
        "File not found"
    }
}

impl fmt::Display for NoFile {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        f.write_str(self.description())
    }
}


pub fn get_response(req: &mut Request) -> Result<iron::Response, iron::IronError> {
    use iron::modifiers::Header;

    let mut file_name = req.url.path().join("/");
    // println!("Request: {:?}", req);
    println!("Request file: {}", file_name);
    if file_name == "" {
        file_name = "index.html".to_owned()
    }

    let header = Header(super::file_content::ctype(&file_name));
    if let Some(content) = super::file_content::get_static(&file_name) {
        Ok(Response::with((header, iron::status::Ok, content)))
    } else if let Ok(content) = super::file_content::get_content_from_disk(&file_name) {
        Ok(Response::with((header, iron::status::Ok, &content as &[u8])))
    } else {
        Err(IronError::new(NoFile, iron::status::NotFound))
    }
}
