#![allow(dead_code)]#![allow(non_upper_case_globals)]
pub static fake: [u8; 1] = [38, ];


pub fn get(name: &str) -> Result<&[u8], &str> {
  match name {
    "http_static/index.html" => Result::Ok(&fake),
    "http_static/3rdpartylicenses.txt" => Result::Ok(&fake),
    "http_static/main.62636f97cac4fa81eebe.bundle.js" => Result::Ok(&fake),
    "http_static/inline.3c2b0a01d63efc5f8551.bundle.js" => Result::Ok(&fake),
    "http_static/doc.png" => Result::Ok(&fake),
    "http_static/polyfills.ab8304790a25edec7f7d.bundle.js" => Result::Ok(&fake),
    "http_static/styles.1d8d1a57c0ce5744a7f0.bundle.css" => Result::Ok(&fake),
    "http_static/vendor.85a84fa43ddcf3e9edcc.bundle.js" => Result::Ok(&fake),
    _=> Result::Err("File Not Found")
  }
}

pub fn list() -> Vec<&'static str> {
  vec![
    "http_static/index.html",
    "http_static/3rdpartylicenses.txt",
    "http_static/main.62636f97cac4fa81eebe.bundle.js",
    "http_static/inline.3c2b0a01d63efc5f8551.bundle.js",
    "http_static/doc.png",
    "http_static/polyfills.ab8304790a25edec7f7d.bundle.js",
    "http_static/styles.1d8d1a57c0ce5744a7f0.bundle.css",
    "http_static/vendor.85a84fa43ddcf3e9edcc.bundle.js",
]}