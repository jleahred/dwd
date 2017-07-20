extern crate iron;


use iron::prelude::*;
use iron::status;
use mount::Mount;

fn main() {
    let mut mount = Mount::new();

    // Serve the shared JS/CSS at /
    mount.mount("/", Static::new(Path::new("http_static")));
    // Serve the static file docs at /doc/
    // mount.mount("/doc/", Static::new(Path::new("target/doc/staticfile/")));
    // // Serve the source code at /src/
    // mount.mount("/src/",
    //             Static::new(Path::new("target/doc/src/staticfile/lib.rs.html")));

    Iron::new(mount).http("127.0.0.1:3000").unwrap();
}

// fn main() {
//     Iron::new(|_: &mut Request| Ok(Response::with((status::Ok, "Hello World! aaaa"))))
//         .http("0.0.0.0:3000")
//         .unwrap();
// }


// extern crate iron;
// extern crate staticfile;
// extern crate mount;

// use iron::prelude::*;
// use iron::status;

// fn main() {
//     let mut mount = Mount::new();

//     // Serve the shared JS/CSS at /
//     mount.mount("/", Static::new(Path::new("http_static")));
//     // Serve the static file docs at /doc/
//     // mount.mount("/doc/", Static::new(Path::new("target/doc/staticfile/")));
//     // // Serve the source code at /src/
//     // mount.mount("/src/",
//     //             Static::new(Path::new("target/doc/src/staticfile/lib.rs.html")));

//     Iron::new(mount).http("127.0.0.1:3000").unwrap();
// }