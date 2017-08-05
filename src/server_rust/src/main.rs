// find by filename
// load pdf
// find inside document
// stop find when a new request arrives
// test memory and cpu


// thread pool
// check unwrap
// check _
// check let _ =

extern crate ws;
extern crate iron;


#[macro_use]
extern crate serde_derive;

use std::thread;
mod core;


fn main() {
    const HTTP_SOCKET: &str = "0.0.0.0:8080";
    const WS_SOCKET: &str = "0.0.0.0:8081";

    let http = thread::spawn(|| core::process_http::run(HTTP_SOCKET));
    let ws = thread::spawn(|| core::wss::run(WS_SOCKET));
    let _ = http.join();
    let _ = ws.join();
}
