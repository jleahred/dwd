import { Injectable, NgZone } from '@angular/core';
import { Subject } from 'rxjs/Subject';

import { ws_send, ws_subscribe_type } from '../ws';
import { Item } from './find.component';


export class Found {
  key0: string;
  key1: string;
  item: Item;
}



@Injectable()
export class FindService {
  private _onEntrance = new Subject<Found>();
  onEntrance = this._onEntrance.asObservable();

  private _onClear = new Subject();
  onClear = this._onClear.asObservable();

  constructor(private ngZone: NgZone) {
    ws_subscribe_type('Found').subscribe(msg => {
      if (msg.type === 'Found') {
        this.ngZone.run(() => this._onEntrance.next(msg));
      }
    });
  }

  find(text2find: string) {
    this._onClear.next();
    ws_send({ 'type': 'Find', 'text2find': text2find });
  }
}


