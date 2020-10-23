import { Component, OnInit } from '@angular/core';
import { YearsService } from '../years.service';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-years',
  templateUrl: './years.component.html',
  styleUrls: ['./years.component.css']
})
export class YearsComponent implements OnInit {

  years: any = [];

  constructor(public rest: YearsService, private route: ActivatedRoute, private router: Router) { }

  ngOnInit() {
    this.getYears();
  }

  getYears() {
    this.years = [];
    this.rest.getYears().subscribe((data: {}) => {
      console.log(data);
      this.years = data;
    });
  }
}
