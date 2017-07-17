import { Injectable } from '@angular/core';
import { Subject } from 'rxjs/Subject';



export class Found {
  key: string;
  val: [{ key: string, val: string[] }];
}



@Injectable()
export class FindService {
  private _onEntrance = new Subject<Found>();
  onEntrance = this._onEntrance.asObservable();

  private _onClear = new Subject();
  onClear = this._onClear.asObservable();

  constructor() { }

  find(text2find: string) {
    this._onClear.next();
    this._onEntrance.next(
      {
        key: 'doc',
        val: [
          { key: 'html', val: ['aaa', 'bbbb'] },
          { key: 'adoc', val: ['ccc', 'dddd'] },
        ]
      });

    this._onEntrance.next(
      {
        key: 'scripts',
        val: [
          { key: 'python', val: ['dddd', 'eeeee'] },
          { key: 'go', val: ['ffff', 'gggggggg'] },
        ]
      });
  }
}
