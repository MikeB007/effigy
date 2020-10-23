import { Component, OnInit } from '@angular/core';
import { YearsService } from '../years.service';
import { ActivatedRoute, Router } from '@angular/router';
import { SafeurlPipe } from '../safe-url.pipe';
import { MediaService } from '../media.service';

@Component({
  selector: 'app-media-player',
  templateUrl: './media-player.component.html',
  styleUrls: ['./media-player.component.css']
})
export class MediaPlayerComponent implements OnInit {

  media: any = [];

  constructor(public rest: MediaService, private route: ActivatedRoute, private router: Router) { }
  ngOnInit() {
    this.rest.getMedia(this.route.snapshot.params['id']).subscribe((data: {}) => {
      console.log(data);
      this.media = data;
    });
  }

}
