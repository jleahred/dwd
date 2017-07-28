// check unwrap
// check _
// check let _ =
// log ng
// reconnect websocket ng


extern crate iron;
extern crate staticfile;
extern crate mount;
extern crate ws;

#[macro_use]
extern crate serde_derive;



use std::thread;
use iron::prelude::*;
use std::path::Path;
use mount::Mount;
use staticfile::Static;
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


fn run_http_server(http_socket: &str) {
    let mut static_path = Mount::new();

    static_path.mount("/", Static::new(Path::new("http_static")));
    println!("http server running on {}", http_socket);
    Iron::new(static_path).http(http_socket).unwrap();

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
