macro_rules! gen_get_includes_bytes{
    ($rel_path:expr, $($file:expr),+) => {
        pub fn get(file_name: &str) -> Option<&'static [u8]> {
            match file_name {
                $(
                    $file => Some(include_bytes!(concat!($rel_path, $file))),
                )+
                _ => None,
            }
        }
    }
}


gen_get_includes_bytes!("../../http_static/",
                        "index.html",
                        "vendor.85a84fa43ddcf3e9edcc.bundle.js",
                        "inline.3c2b0a01d63efc5f8551.bundle.js",
                        "3rdpartylicenses.txt",
                        "styles.1d8d1a57c0ce5744a7f0.bundle.css",
                        "polyfills.ab8304790a25edec7f7d.bundle.js",
                        "main.62636f97cac4fa81eebe.bundle.js",
                        "doc.png");
