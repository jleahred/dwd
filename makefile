.PHONY: all
all: ng embed install


.PHONY: ng
ng:
	cd src/ng; ng build --target=production --environment=prod


.PHONY: embed
embed:
	cd src/server_rust; rust-embed http_static src/core/http_static.rs

.PHONY: install
install:
	cargo uninstall dwd || true; cd src/server_rust; cargo build --release; cargo install
