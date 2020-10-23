import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { YearsDetailsComponent } from './years-details.component';

describe('YearsDetailsComponent', () => {
  let component: YearsDetailsComponent;
  let fixture: ComponentFixture<YearsDetailsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ YearsDetailsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(YearsDetailsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
