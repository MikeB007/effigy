import { Component, OnInit } from '@angular/core';
import { YearsService } from '../years.service';
import { ActivatedRoute, Router } from '@angular/router';
import { SafeurlPipe } from '../safe-url.pipe';

@Component({
  selector: 'app-years-details',
  templateUrl: './years-details.component.html',
  styleUrls: ['./years-details.component.css']
})
export class YearsDetailsComponent implements OnInit {

  media: any = [];

  constructor(public rest: YearsService, private route: ActivatedRoute, private router: Router) { }
  ngOnInit() {
    this.rest.getYearsD(this.route.snapshot.params['id']).subscribe((data: {}) => {
      console.log(data);
      this.media = data;
    });
  }

}
