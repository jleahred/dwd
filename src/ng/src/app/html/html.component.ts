import { NgZone } from '@angular/core';
import { Component, OnInit } from '@angular/core';
import { ws_subscribe_type } from '../ws';
import { Status, AppService } from '../app.service';


class HtmlCont {
  type: string;
  data: string;
}


@Component({
  selector: 'app-html',
  templateUrl: './html.component.html',
  styleUrls: ['./html.component.css']
})
export class HtmlComponent implements OnInit {

  public content: HtmlCont;


  constructor(private ngZone: NgZone, private appserv: AppService) {
  }


  ngOnInit() {
    ws_subscribe_type('Html').subscribe(msg => {
      this.appserv.status = Status.Html;
      this.ngZone.run(() => {
        const html_content = msg as HtmlCont;
        this.content = html_content;
      });
    });
  }

  isActive(): boolean {
    return this.content !== undefined && this.appserv.status === Status.Html;
  }

}
