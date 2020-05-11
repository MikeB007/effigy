import { Component, OnInit } from '@angular/core';
import {ActivatedRoute, Router} from '@angular/router';
import {TimelineService} from '../timeline.service';

@Component({
  selector: 'app-timeline',
  templateUrl: './timeline.component.html',
  styleUrls: ['./timeline.component.css']
})
export class TimelineComponent implements OnInit {

  timeline: any = [];

  constructor(public rest: TimelineService, private route: ActivatedRoute, private router: Router) { }
  ngOnInit() {
    this.rest.getTimeline(this.route.snapshot.params['id']).subscribe((data: {}) => {
      console.log(data);
      this.timeline = data;
    });
  }
}
