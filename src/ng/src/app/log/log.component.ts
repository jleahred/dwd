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
    this.ls.on_log = (line: string) => this.on_log(line);
    this.wss.subscribe_type('Log').subscribe(msg => {
      this.on_log((new Date()).toLocaleTimeString() + ' REMOTE ' + msg);
    });
  }

  on_log(line: string) {
    this.content = line + '\n' + this.content;
  }

}
