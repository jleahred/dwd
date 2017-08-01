// check unwrap
// check _
// check let _ =
// log ng
// reconnect websocket ng

extern crate iron;
use iron::status;
use iron::prelude::*;
extern crate ws;

#[macro_use]
extern crate serde_derive;



use std::thread;
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
    println!("http server running on {}", http_socket);
    Iron::new(|req: &mut Request| get_http_response(req))
        .http(http_socket)
        .unwrap();
}



fn get_http_response(req: &mut Request) -> Result<iron::Response, iron::IronError> {
    use iron::modifiers::Header;

    let mut file_name = req.url.path().join("/");
    if file_name == "" {
        file_name = "index.html".to_owned()
    }

    let content = core::file_cont::get(&file_name);
    Ok(Response::with((Header(core::file_cont::ctype(&file_name)), status::Ok, content)))
}
