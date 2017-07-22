import { window } from 'rxjs/operator/window';
import { Component, OnInit, Input } from '@angular/core';
import { element } from 'protractor';
import { FindService, Found } from './find.service';

class Model {
  founds: { [key: string]: { [key: string]: [string] } } = {};
}


@Component({
  selector: 'app-find',
  templateUrl: './find.component.html',
  styleUrls: ['./find.component.css'],
  providers: [FindService]
})
export class FindComponent implements OnInit {

  model = new Model;

  text2find: string;

  constructor(private fs: FindService) {
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
      this.model.founds[found.key0][found.key1] = [] as [string];
    }
    for (const v of found.val) {
      this.model.founds[found.key0][found.key1].push(v);
    }

    //  dirty trick
    this.model.founds = JSON.parse(JSON.stringify(this.model.founds));
    //  dirty trick
  }

  onModifText2Find(event: any) {
    this.fs.find(this.text2find);
  }
}
