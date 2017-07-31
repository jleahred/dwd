pub mod wss;

#[cfg(debug_assertions)]
pub mod http_static_fake;
#[cfg(not(debug_assertions))]
pub mod http_static;


mod find;
mod send_file_cont;
mod proto;