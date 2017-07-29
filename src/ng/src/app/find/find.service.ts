import { Injectable, NgZone } from '@angular/core';
import { Subject } from 'rxjs/Subject';

import { WsService } from '../ws.service';
import { Item } from './find.component';

import { AppService, Status } from '../app.service';


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

  constructor(private ngZone: NgZone, private appService: AppService, private wss: WsService) {
    this.wss.subscribe_type('Found').subscribe(msg => {
      this.ngZone.run(() => this._onEntrance.next(msg));
    });
  }


  find(text2find: string) {
    this.appService.status = Status.Found;
    this._onClear.next();
    this.wss.send({ 'type': 'Find', 'text2find': text2find });
  }
}


