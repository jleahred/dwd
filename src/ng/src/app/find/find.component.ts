import { window } from 'rxjs/operator/window';
import { Component, OnInit } from '@angular/core';
import { element } from 'protractor';

class Model {
  entrances: { [key: string]: { [key: string]: [string] } } = {}
}


@Component({
  selector: 'app-find',
  templateUrl: './find.component.html',
  styleUrls: ['./find.component.css']
})
export class FindComponent implements OnInit {

  model = new Model;

  constructor() { }

  ngOnInit() {
    // remove, just for testing
    this.insertElement("html", "src", ["lulululu", "lalalala"]);
    this.insertElement("html", "src2", ["lulululu22", "lulululu22"]);
    this.insertElement("adoc", "doc", ["lulululu33", "lulululu22"]);
    this.insertElement("adoc", "doc2", ["lulululu44"]);
    this.insertElement("adoc", "doc3", ["2222"]);
  }

  insertElement(key1: string, key2: string, value: [string]) {
    if (this.model.entrances[key1] == null) {
      this.model.entrances[key1] = {};
    }
    this.model.entrances[key1][key2] = value;
  }
}
