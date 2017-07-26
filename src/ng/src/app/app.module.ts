import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule } from '@angular/forms';

import { AppComponent } from './app.component';
import { FindComponent } from './find/find.component';
import { FindService } from './find/find.service';
import { KeysPipe } from './keys.pipe';
import { MenuComponent } from './menu/menu.component';

@NgModule({
  declarations: [
    AppComponent,
    FindComponent,
    KeysPipe,
    MenuComponent
  ],
  imports: [
    BrowserModule,
    FormsModule
  ],
  providers: [FindService],
  bootstrap: [AppComponent]
})
export class AppModule { }
