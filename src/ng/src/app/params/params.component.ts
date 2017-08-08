import { Component, OnInit } from '@angular/core';


enum ParamType {
  Input,
  Date,
  Time,
}

class Param {
  paramType: ParamType;
  value: string;
}

class Model {
  params: Param[] = new Array();
}


@Component({
  selector: 'app-params',
  templateUrl: './params.component.html',
  styleUrls: ['./params.component.css']
})
export class ParamsComponent implements OnInit {

  model: Model;

  constructor() {
    this.model = new Model();
    this.model.params.push({ paramType: ParamType.Input, value: '' });
  }

  ngOnInit() {
  }

}
