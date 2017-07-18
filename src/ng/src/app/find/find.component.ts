import { window } from 'rxjs/operator/window';
import { Component, OnInit, Input } from '@angular/core';
import { element } from 'protractor';
import { FindService, Found } from './find.service';

class Model {
  founds: { [key: string]: { [key: string]: [string] } } = {}
}


@Component({
  selector: 'app-find',
  templateUrl: './find.component.html',
  styleUrls: ['./find.component.css'],
  providers: [FindService]
})
export class FindComponent implements OnInit {

  model = new Model;
  @Input() text2find: string;
  fs: FindService;

  constructor(fs: FindService) {
    this.fs = fs;
    this.fs.onEntrance.subscribe(elem => this.insertElement(elem));
    this.fs.onClear.subscribe(() => this.model.founds = {});
  }

  ngOnInit() {
    this.fs.find('text to find');
    this.fs.find('this.text2find');
  }

  insertElement(found: Found) {
    if (this.model.founds[found.key0] === undefined) {
      this.model.founds[found.key0] = {};
    }
    if (this.model.founds[found.key0][found.key1] === undefined) {
      this.model.founds[found.key0][found.key1] = [] as [string];
    }
    for (let i in found.val) {
      this.model.founds[found.key0][found.key1].push(found.val[i]);
    }
  }

  onModifText2Find(event: KeyboardEvent) {
    console.log(event);
    console.log(this.text2find);
    this.fs.find(this.text2find);
  }
}
