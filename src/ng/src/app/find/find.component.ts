import { window } from 'rxjs/operator/window';
import { Component, OnInit } from '@angular/core';
import { element } from 'protractor';
import { FindService, Found } from './find.service';

class Model {
  foundList: Found[] = [];
}


@Component({
  selector: 'app-find',
  templateUrl: './find.component.html',
  styleUrls: ['./find.component.css'],
  providers: [FindService]
})
export class FindComponent implements OnInit {

  model = new Model;
  fs: FindService;

  constructor(fs: FindService) {
    this.fs = fs;
    this.fs.onEntrance.subscribe(elem => this.insertElement(elem));
    this.fs.onClear.subscribe(() => this.model.foundList = []);
  }

  ngOnInit() {
    this.fs.find('text to find');
    this.fs.find('text to find');
  }

  insertElement(found: Found) {
    console.log(found);
    this.model.foundList.push(found);
  }
}
