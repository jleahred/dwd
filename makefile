.PHONY: all
all: ng embed install


.PHONY: ng
ng:
	cd src/ng; ng build --target=production --environment=prod


.PHONY: embed
embed:
	rm -rf src/server_rust/http_static
	cp -r src/ng/dist src/server_rust/http_static
	cd src/server_rust; embed_dir http_static src/core/http_static2.rs

.PHONY: install
install:
	cargo uninstall dwd || true; cd src/server_rust; cargo build --release; cargo install
