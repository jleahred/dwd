package main

import (
	"log"
	"net/http"

	"github.com/gorilla/websocket"
)

func main() {
	fs := http.FileServer(http.Dir("html"))
	http.Handle("/", fs)
	log.Println("Listening...")
	http.ListenAndServe(":8080", nil)
}

// func handler(w http.ResponseWriter, r *http.Request) {
// 	fmt.Fprintf(w, "Hi there")
// }

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

func handler(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println(err)
		return
	}
	for {
		messageType, p, err := conn.ReadMessage()
		if err != nil {
			return
		}
		if err := conn.WriteMessage(messageType, p); err != nil {
			return err
		}
	}
}
