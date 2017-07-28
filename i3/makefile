.PHONY: default
default:
	i3-msg 'workspace 2; append_layout /home/maiquel/inet.prj/web/dwd/i3/i3_rust.json'
	cd ../src/server_rust/; konsole & chromium-browser & code . 
	sleep 2
	i3-msg 'workspace 3; append_layout /home/maiquel/inet.prj/web/dwd/i3/i3_ng.json'
	cd ../src/ng/; konsole -e 'make serve' & make chromium_debug & code . 

.PHONY: explicit
explicit:
	i3-msg 'workspace 8; append_layout /home/maiquel/inet.prj/web/dwd/i3/i3_rust.json'
	cd ../src/server_rust/; konsole & chromium-browser & code . 
	sleep 5
	i3-msg 'workspace 9; append_layout /home/maiquel/inet.prj/web/dwd/i3/i3_ng.json'
	#cd ../src/ng/; konsole -hold -e 'make serve_explicit&' & make chromium_browser_debug & code .
	cd ../src/ng/; konsole & make chromium_browser_debug & code .
