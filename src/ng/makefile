.PHONY: chromium_debug
chromium_debug:
	chromium --remote-debugging-port=9222 --user-data-dir=remote-profile 127.0.0.1:4200

.PHONY: chromium_browser_debug
chromium_browser_debug:
	chromium-browser --remote-debugging-port=9222 --user-data-dir=remote-profile 192.168.7.1:4200

.PHONY: serve
serve:
	ng serve

	
.PHONY: serve_explicit
serve_explicit:
	ng serve --host 192.168.7.1



