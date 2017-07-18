import { Injectable } from '@angular/core';
import { Subject } from 'rxjs/Subject';



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

  constructor() { }

  find(text2find: string) {
    this._onClear.next();

    this._onEntrance.next(
      {
        key0: text2find,
        key1: text2find,
        val: ['aaa', 'bbbb']
      },
    );

    this._onEntrance.next(
      {
        key0: 'doc',
        key1: 'html',
        val: ['aaa', 'bbbb']
      },
    );
    this._onEntrance.next(
      {
        key0: 'doc',
        key1: 'adoc',
        val: ['cccc', 'dddd']
      },
    );
    this._onEntrance.next(
      {
        key0: 'script',
        key1: 'go',
        val: ['eeee', 'ffff']
      },
    );

  }
}
