import { Injectable } from '@angular/core';

export enum Status {
  Found,
  Html,
}


@Injectable()
export class AppService {

  public status: Status;

  constructor() { this.status = Status.Found; }
}
