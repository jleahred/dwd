import { Component, OnInit } from '@angular/core';
import { FindService, Found } from '../find/find.service';

import { window } from 'rxjs/operator/window';
import { Input } from '@angular/core';
import { element } from 'protractor';


@Component({
  selector: 'app-menu',
  templateUrl: './menu.component.html',
  styleUrls: ['./menu.component.css']
})
export class MenuComponent implements OnInit {

  text2find: string;

  constructor(private fs: FindService) { }

  ngOnInit() {
  }

  onModifText2Find(event: any) {
    this.fs.find(this.text2find);
  }

}
