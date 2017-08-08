import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { AppComponent } from './app.component';
import { AppService } from './app.service';
import { FindComponent } from './find/find.component';
import { FindService } from './find/find.service';
import { KeysPipe } from './keys.pipe';
import { MenuComponent } from './menu/menu.component';
import { LogComponent } from './log/log.component';
import { LogService } from './log/log.service';
import { WsService } from './ws.service';
import { ParamsComponent } from './params/params.component';

@NgModule({
  declarations: [
    AppComponent,
    FindComponent,
    KeysPipe,
    MenuComponent,
    LogComponent,
    ParamsComponent
  ],
  imports: [
    BrowserModule,
    FormsModule
  ],
  providers: [AppService, LogService, WsService, FindService],
  bootstrap: [AppComponent]
})
export class AppModule { }
