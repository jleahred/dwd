import { Injectable } from '@angular/core';

@Injectable()
export class LogService {

  constructor() {
  }

  public on_log: (this, line: string) => void;

  write(data: any, remote = false) {
    // const now = new Date();
    // const line = now.toLocaleTimeString() + '.  ';
    // const line = now.toISOString() + '  ';
    if (this.on_log !== undefined) {
      this.on_log(data);
    }
    console.log(data);
  }
}
