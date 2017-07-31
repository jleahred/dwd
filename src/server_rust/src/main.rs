// check unwrap
// check _
// check let _ =
// log ng
// reconnect websocket ng


extern crate iron;
use iron::status;
extern crate staticfile;
extern crate mount;
extern crate ws;

#[macro_use]
extern crate serde_derive;



use std::thread;
use iron::prelude::*;
use iron::mime::Mime;
// use std::path::Path;
// use mount::Mount;
// use staticfile::Static;
use ws::listen;

mod core;




fn main() {
    const HTTP_SOCKET: &str = "0.0.0.0:8080";
    const WS_SOCKET: &str = "0.0.0.0:8081";

    let http = thread::spawn(|| run_http_server(HTTP_SOCKET));
    let ws = thread::spawn(|| run_web_socket(WS_SOCKET));
    let _ = http.join();
    let _ = ws.join();
}


fn run_web_socket(ws_socket: &str) {
    println!("WS server running on {}", ws_socket);
    if let Err(error) = listen(ws_socket, |out| {
        move |msg| {
            println!("Server got message '{}'. ", msg);
            core::wss::process_ws_msg(msg, &out)
        }

    }) {
        println!("Failed to create WebSocket due to {:?}", error);
    }
}


fn run_http_server(http_socket: &str) {
    // let mut static_path = Mount::new();

    // static_path.mount("/", Static::new(Path::new("http_static")));
    // println!("http server running on {}", http_socket);
    // Iron::new(static_path).http(http_socket).unwrap();

    println!("http server running on {}", http_socket);
    Iron::new(|req: &mut Request| {
            // println!("Request: {:?}", req.url.path().join("/"));
            // let content_type = "text/html".parse::<Mime>().unwrap();
            // Ok(Response::with((status::Ok, get_file_content(&req.url.path().join("/")))))
            // Ok(Response::with((content_type,
            //                    status::Ok,
            //                    get_file_content(&req.url.path().join("/")))))
        //     use iron::headers::{ContentLength, ContentType, ETag, EntityTag};
        // use iron::modifiers::Header;
        // use iron::mime::{Mime, TopLevel, SubLevel};

        //     let has_ct = req.headers.get::<ContentType>();
        //     let cont_type = match has_ct {
        //         None => ContentType(Mime(TopLevel::Text, SubLevel::Plain, vec![])),
        //         Some(t) => t.clone(),
        //     };
        //     // Response::with((status::Ok, Header(cont_type), Header(ContentLength(metadata.len()))))
        //     Ok(Response::with((Header(cont_type),
        //                        status::Ok,
        //                        get_file_content(&req.url.path().join("/")))))
            get_http_response(req)
        })
        .http(http_socket)
        .unwrap();
}

fn get_http_response(req: &mut Request) -> Result<iron::Response, iron::IronError> {
    use iron::headers::{ContentLength, ContentType, ETag, EntityTag};
    use iron::modifiers::Header;
    use iron::mime::{Mime, TopLevel, SubLevel};

    let has_ct = req.headers.get::<ContentType>();
    println!("{:?}", req);
    println!("{:?}", has_ct);
    let orig_cont_type = match has_ct {
        None => ContentType(Mime(TopLevel::Text, SubLevel::Plain, vec![])),
        Some(t) => t.clone(),
    };
    // Response::with((status::Ok, Header(cont_type), Header(ContentLength(metadata.len()))))

    let  file_name = req.url.path().join("/");

    // let (fname, cont_type) = match orig_file_name == "" {
    //     true => ("http_static/index.html".to_owned(), ContentType(Mime(TopLevel::Text, SubLevel::Html, vec![]))),
    //     false => (format!("http_static/{}", orig_file_name), orig_cont_type),
    // };

    let (content, cont_type) = get_file_content(&file_name);
    let cont_type = match cont_type {
        Some(ct) => ct,
        None => orig_cont_type,
    };
    println!("{:?}", cont_type);
    Ok(Response::with((Header(cont_type), status::Ok, content)))
}

// fn response_with_cache<P: AsRef<Path>>(&self,
//                                            req: &mut Request,
//                                            path: P,
//                                            size: u64,
//                                            modified: Timespec) -> IronResult<Response> {
//         use iron::headers::{CacheControl, LastModified, CacheDirective, HttpDate};
//         use iron::headers::{ContentLength, ContentType, ETag, EntityTag};
//         use iron::method::Method;
//         use iron::mime::{Mime, TopLevel, SubLevel};
//         use iron::modifiers::Header;

//         let seconds = self.duration.as_secs() as u32;
//         let cache = vec![CacheDirective::Public, CacheDirective::MaxAge(seconds)];
//         let metadata = fs::metadata(path.as_ref());

//         let metadata = try!(metadata.map_err(|e| IronError::new(e, status::InternalServerError)));

//         let mut response = if req.method == Method::Head {
//             let has_ct = req.headers.get::<ContentType>();
//             let cont_type = match has_ct {
//                 None => ContentType(Mime(TopLevel::Text, SubLevel::Plain, vec![])),
//                 Some(t) => t.clone()
//             };
//             Response::with((status::Ok, Header(cont_type), Header(ContentLength(metadata.len()))))
//         } else {
//             Response::with((status::Ok, path.as_ref()))
//         };

//         response.headers.set(CacheControl(cache));
//         response.headers.set(LastModified(HttpDate(time::at(modified))));
//         response.headers.set(ETag(EntityTag::weak(format!("{0:x}-{1:x}.{2:x}", size, modified.sec, modified.nsec))));

//         Ok(response)
//     }

    use iron::headers::{ContentLength, ContentType, ETag, EntityTag};
fn get_file_content(file_name: &str) -> (&[u8], Option<ContentType>) {
    use iron::modifiers::Header;
    use iron::mime::{Mime, TopLevel, SubLevel};
    
    #[cfg(debug_assertions)]
    use core::http_static_fake as http_static;
    #[cfg(not(debug_assertions))]
    use core::http_static;

    let (fname, cont_type) = match file_name == "" {
        true => ("http_static/index.html".to_owned(), Some(ContentType(Mime(TopLevel::Text, SubLevel::Html, vec![])))),
        false => (format!("http_static/{}", file_name), None),
    };

    let fname = match file_name == "" {
        true => "http_static/index.html".to_owned(),
        false => format!("http_static/{}", file_name),
    };

    match http_static::get(&fname) {
        Ok(content) => (content, cont_type),
        Err(_) => (&[] as &[u8], None),
    }
}