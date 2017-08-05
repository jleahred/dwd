import { window } from 'rxjs/operator/window';
import { Component, OnInit, Input } from '@angular/core';
import { element } from 'protractor';
import { FindService, Found } from './find.service';
import { WsService } from '../ws.service';
import { LogService } from '../log/log.service';

class Link { Link: string; }
class Command { Command: any; }


export type Item = Link | Command;
// enum Item {
//   Link ; Command;
// }

class Model {
  founds: { [key: string]: { [key: string]: [Link | Command] } } = {};
}


@Component({
  selector: 'app-find',
  templateUrl: './find.component.html',
  styleUrls: ['./find.component.css']
})
export class FindComponent implements OnInit {

  model = new Model;

  text2find: string;

  constructor(private log: LogService, private wss: WsService, private fs: FindService) {
  }

  ngOnInit() {
    this.fs.onEntrance.subscribe(elem => {
      this.insertElement(elem);
    });
    this.fs.onClear.subscribe(() => this.model.founds = {});
  }

  insertElement(found: Found) {
    if (this.model.founds[found.key0] === undefined) {
      this.model.founds[found.key0] = {};
    }
    if (this.model.founds[found.key0][found.key1] === undefined) {
      this.model.founds[found.key0][found.key1] = [] as [Item];
    }
    this.model.founds[found.key0][found.key1].push(found.item);

    //  dirty trick
    this.model.founds = JSON.parse(JSON.stringify(this.model.founds));
    //  dirty trick
  }

  onClick(item: Item) {
    this.log.write(JSON.stringify(item));
    // location.href = this.getLinkItem(item);
  }

  getTextItem(item: Item): string {
    const link = (item as Link).Link;
    if (link !== undefined) {
      return link;
    }
    return 'not supported to string Item' + JSON.stringify(item);
  }
  getLinkItem(item: Item): string | undefined {
    const link = (item as Link).Link;
    if (link !== undefined) {
      return link;
    }
    return undefined;
  }
}
