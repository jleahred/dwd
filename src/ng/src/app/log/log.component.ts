import { Component, OnInit } from '@angular/core';
import { LogService } from './log.service';
import { WsService } from '../ws.service';

@Component({
  selector: 'app-log',
  templateUrl: './log.component.html',
  styleUrls: ['./log.component.css']
})
export class LogComponent implements OnInit {

  public content = '';

  constructor(private ls: LogService, private wss: WsService) {
  }

  ngOnInit() {
    this.ls.on_log = (data: any) => this.on_log(data);
    this.wss.subscribe_type('Log').subscribe(data => {
      this.on_log(data, true);
    });
  }

  on_log(data: any, remote = false) {
    const now = new Date();
    let line = now.toLocaleTimeString() + '. ';
    if (remote) {
      line += ' REMOTE> ';
    }
    if (typeof data === 'object') {
      line += JSON.stringify(data);
    } else {
      line += data.toString();
    }
    this.content = line + '\n' + this.content;
  }

}
