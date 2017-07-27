.PHONY: default
default:
	i3-msg 'workspace 2; append_layout /home/maiquel/inet.prj/web/dwd/i3/i3_rust.json'
	cd ../src/server_rust/; konsole & chromium & code . &
	sleep 2
	i3-msg 'workspace 3; append_layout /home/maiquel/inet.prj/web/dwd/i3/i3_ng.json'
	cd ../src/ng/; konsole -e 'make serve' & make chromium_debug & code . &
