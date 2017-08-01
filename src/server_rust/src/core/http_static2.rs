

static F1: &'static [u8] = include_bytes!("../../http_static/index.html");
static F2: &'static [u8] = include_bytes!("../../http_static/vendor.85a84fa43ddcf3e9edcc.bundle.\
                                           js");
static F3: &'static [u8] = include_bytes!("../../http_static/inline.3c2b0a01d63efc5f8551.bundle.\
                                           js");
static F4: &'static [u8] = include_bytes!("../../http_static/3rdpartylicenses.txt");
static F5: &'static [u8] = include_bytes!("../../http_static/styles.1d8d1a57c0ce5744a7f0.bundle.\
                                           css");
static F6: &'static [u8] = include_bytes!("../../http_static/polyfills.ab8304790a25edec7f7d.\
                                           bundle.js");
static F7: &'static [u8] = include_bytes!("../../http_static/main.62636f97cac4fa81eebe.bundle.js");
static F8: &'static [u8] = include_bytes!("../../http_static/doc.png");


pub fn get(file_name: &str) -> Option<&'static [u8]> {
    match file_name {
        "index.html" => Some(F1),
        "vendor.85a84fa43ddcf3e9edcc.bundle.js" => Some(F2),
        "inline.3c2b0a01d63efc5f8551.bundle.js" => Some(F3),
        "http_static/3rdpartylicenses.txt" => Some(F4),
        "styles.1d8d1a57c0ce5744a7f0.bundle.css" => Some(F5),
        "polyfills.ab8304790a25edec7f7d.bundle.js" => Some(F6),
        "main.62636f97cac4fa81eebe.bundle.js" => Some(F7),
        "doc.png" => Some(F8),

        _ => None,
    }
}