import { Injectable } from '@angular/core';
import { Subject } from 'rxjs/Subject';
import { Observable } from 'rxjs/Rx';

import { LogService } from './log/log.service';

@Injectable()
export class WsService {

  private ws: WebSocket;
  public _onMessage2: { [type: string]: Subject<any> } = {};


  constructor(private ls: LogService) {
    this.ws = new WebSocket('ws://127.0.0.1:8081/');
    this.ws.onopen = (event: Event) => {
      this.ls.log('Socket has been opened!');
      // console.log('Socket has been opened!');
    };
    this.ws.onmessage = (msg: MessageEvent) => {
      // console.log(msg.data);
      const rec = JSON.parse(msg.data);
      if (this._onMessage2[rec.type] !== undefined) {
        this._onMessage2[rec.type].next(rec);
      } else {
        this.ls.log('received message with no subscription' + JSON.stringify(rec));
        // console.log('received message with no subscription' + JSON.stringify(rec));
      }
    };

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
