import { Injectable, NgZone } from '@angular/core';
import { Subject } from 'rxjs/Subject';

import { ws_onmessage, ws_send } from '../ws';


export class Found {
  key0: string;
  key1: string;
  val: string[];
}



@Injectable()
export class FindService {
  private _onEntrance = new Subject<Found>();
  onEntrance = this._onEntrance.asObservable();

  private _onClear = new Subject();
  onClear = this._onClear.asObservable();

  constructor(private ngZone: NgZone) {
    ws_onmessage.subscribe(msg => {
      this.ngZone.run(() => this._onEntrance.next(msg));
    });
  }


  find(text2find: string) {
    this._onClear.next();
    ws_send(text2find);
  }
}


