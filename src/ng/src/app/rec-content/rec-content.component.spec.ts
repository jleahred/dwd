import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RecContentComponent } from './rec-content.component';

describe('RecContentComponent', () => {
  let component: RecContentComponent;
  let fixture: ComponentFixture<RecContentComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [RecContentComponent]
    })
      .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(RecContentComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should be created', () => {
    expect(component).toBeTruthy();
  });
});
