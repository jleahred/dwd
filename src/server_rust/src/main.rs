extern crate iron;
extern crate staticfile;
extern crate mount;
extern crate ws;


use iron::prelude::*;
use std::path::Path;
use mount::Mount;
use staticfile::Static;
use ws::listen;

const SERVER_SOCKET: &str = "0.0.0.0:8080";

fn main() {
    let mut static_path = Mount::new();

    static_path.mount("/", Static::new(Path::new("http_static")));
    println!("server running on {}", SERVER_SOCKET);
    Iron::new(static_path).http(SERVER_SOCKET).unwrap();
}


// fn main() {

//     // Setup logging
//     env_logger::init().unwrap();

//     // Listen on an address and call the closure for each connection
//     if let Err(error) = listen("127.0.0.1:3012", |out| {

//         // The handler needs to take ownership of out, so we use move
//         move |msg| {

//             // Handle messages received on this connection
//             println!("Server got message '{}'. ", msg);

//             // Use the out channel to send messages back
//             out.send(msg)
//         }

//     }) {
//         // Inform the user of failure
//         println!("Failed to create WebSocket due to {:?}", error);
//     }

// }