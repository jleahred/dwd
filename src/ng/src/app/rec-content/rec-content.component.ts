import { Component, OnInit } from '@angular/core';
import { WsService } from '../ws.service';
import { LogService } from '../log/log.service';

@Component({
  selector: 'app-rec-content',
  templateUrl: './rec-content.component.html',
  styleUrls: ['./rec-content.component.css']
})
export class RecContentComponent implements OnInit {

  content = '';

  constructor(private log: LogService, private wss: WsService) { }

  ngOnInit() {
    this.wss.subscribe_type('SimpleTxt').subscribe(msg => this.onRecContent(msg as string));
  }

  onRecContent(msg: any) {
    this.content = msg.text;
  }
}

