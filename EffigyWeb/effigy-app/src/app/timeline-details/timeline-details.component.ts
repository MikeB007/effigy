import { Component, OnInit } from '@angular/core';
import {TimelineDetailsService} from '../timeline-details.service';
import {ActivatedRoute, Router} from '@angular/router';

@Component({
  selector: 'app-timeline-details',
  templateUrl: './timeline-details.component.html',
  styleUrls: ['./timeline-details.component.css']
})
export class TimelineDetailsComponent implements OnInit {

  timeline: any = [];

  constructor(public rest: TimelineDetailsService, private route: ActivatedRoute, private router: Router) { }
  ngOnInit() {
    this.rest.getTimelinebyYearMonth(this.route.snapshot.params[ 'id' ],this.route.snapshot.params[ 'id2' ]).subscribe((data: {}) => {
      console.log(data);
      this.timeline = data;
    });
  }
}
