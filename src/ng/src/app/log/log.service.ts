import { Injectable } from '@angular/core';

@Injectable()
export class LogService {

  constructor() {
  }

  public on_log: (this, line: string) => void;

  log(data: any, remote = false) {
    const now = new Date();
    const line = now.toLocaleTimeString() + '.  ';
    // const line = now.toISOString() + '  ';
    if (this.on_log !== undefined) {
      if (typeof data === 'object') {
        this.on_log(line + JSON.stringify(data));
      } else {
        this.on_log(line + data.toString());
      }
    }
    console.log(line);
  }
}
