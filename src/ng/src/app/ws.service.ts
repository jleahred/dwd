import { Injectable } from '@angular/core';
import { Subject } from 'rxjs/Subject';
import { Observable, Subscription } from 'rxjs/Rx';

import { LogService } from './log/log.service';
import { Status } from './app.service';

@Injectable()
export class WsService {

  private ws: WebSocket;
  private _onMessage2: { [type: string]: Subject<any> } = {};
  private timer;
  private subtimer: Subscription;

  constructor(private log: LogService) {
    this.connect();
    this.timer = Observable.timer(2000, 8000);
    // subscribing to a observable returns a subscription object
    this.subtimer = this.timer.subscribe(_ => this.checkConnection());
  }

  connect() {
    let port = String(8081);
    if (location.port !== String(4200)) {   //  4200 -> developing
      port = String(Number(location.port) + 1);
    }
    const socket_url = 'ws://' + location.hostname + ':' + port;
    this.log.write('Connecting ws on  ' + socket_url);
    this.ws = new WebSocket(socket_url);
    this.ws.onopen = (event: Event) => {
      this.log.write('Socket has been opened! on  ' + socket_url);
    };
    this.ws.onmessage = (msg: MessageEvent) => {
      // console.log(msg);
      const rec = JSON.parse(msg.data);
      if (this._onMessage2[rec.type] !== undefined) {
        this._onMessage2[rec.type].next(rec);
      } else {
        this.log.write('received message with no subscription' + JSON.stringify(rec));
      }
    };

    this.ws.onclose = (msg: CloseEvent) => {
      this.log.write('Socket has been closed!' + JSON.stringify(msg));
    };

    this.ws.onerror = (msg: Event) => {
      this.log.write('Socket has been closed!' + JSON.stringify(msg));
    };
  }

  checkConnection() {
    if (this.ws.readyState === this.ws.CLOSED) {
      this.log.write('Trying ws reconnect...');
      this.connect();
    }
  }

  public subscribe_type(type: string): Observable<any> {
    if (this._onMessage2[type] === undefined) {
      this._onMessage2[type] = new Subject<any>();
    }
    return this._onMessage2[type].asObservable();
  }

  public send(data: any) {
    this.ws.send(JSON.stringify(data));
  }

}
