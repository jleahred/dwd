//  autogenerated  embed_dir  on ...


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
          "vendor.b9fe42a3611cccdfb0f3.bundle.js",
          "index.html",
          "main.d5e1fb532a815fabf5b2.bundle.js",
          "inline.7329a2f9f9599a781908.bundle.js",
          "assets/bs.3.3.7/css/bootstrap.min.css",
          "assets/bs.3.3.7/css/bootstrap-theme.css",
          "assets/bs.3.3.7/css/bootstrap-theme.min.css",
          "assets/bs.3.3.7/js/bootstrap.min.js",
          "assets/bs.3.3.7/fonts/glyphicons-halflings-regular.ttf",
          "assets/bs.3.3.7/fonts/glyphicons-halflings-regular.woff",
          "assets/bs.3.3.7/fonts/glyphicons-halflings-regular.svg",
          "assets/bs.3.3.7/fonts/glyphicons-halflings-regular.eot",
          "assets/bs.3.3.7/fonts/glyphicons-halflings-regular.woff2",
          "assets/jquery3.2.1.min.js",
          "3rdpartylicenses.txt",
          "styles.1d8d1a57c0ce5744a7f0.bundle.css",
          "polyfills.ab8304790a25edec7f7d.bundle.js",
          "doc.png"
);
