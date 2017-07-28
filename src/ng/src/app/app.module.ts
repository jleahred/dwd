import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { AppComponent } from './app.component';
import { AppService } from './app.service';
import { FindComponent } from './find/find.component';
import { FindService } from './find/find.service';
import { KeysPipe } from './keys.pipe';
import { MenuComponent } from './menu/menu.component';
import { HtmlComponent } from './html/html.component';

@NgModule({
  declarations: [
    AppComponent,
    FindComponent,
    KeysPipe,
    MenuComponent,
    HtmlComponent
  ],
  imports: [
    BrowserModule,
    FormsModule
  ],
  providers: [AppService, FindService],
  bootstrap: [AppComponent]
})
export class AppModule { }
