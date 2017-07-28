import * as stream from 'stream';
import { observable } from 'rxjs/symbol/observable';
import { Observable } from 'rxjs/Rx';
import { parse, } from 'ts-node';
import { Subject } from 'rxjs/Subject';
import { cfgtesting } from '../config';


let ws: WebSocket;

let _onMessage2: { [type: string]: Subject<any> } = {};


if (cfgtesting() === false) {

  ws = new WebSocket('ws://127.0.0.1:8081/');
  ws.onopen = (event: Event) => {
    console.log('Socket has been opened!');
  };
  ws.onmessage = (msg: MessageEvent) => {
    console.log(msg.data);
    let rec = JSON.parse(msg.data);
    if (_onMessage2[rec.type] !== undefined) {
      _onMessage2[rec.type].next(rec);
    } else {
      console.log('received message with no subscription' + JSON.stringify(rec));
    }
  };
}

export function ws_subscribe_type(type: string): Observable<any> {
  if (_onMessage2[type] === undefined) {
    _onMessage2[type] = new Subject<any>();
  }
  return _onMessage2[type].asObservable();
}




export function ws_send(data: any) {
  ws.send(JSON.stringify(data))
}

