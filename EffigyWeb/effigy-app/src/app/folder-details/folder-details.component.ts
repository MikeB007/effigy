import { Component, OnInit } from '@angular/core';
import { FolderService } from '../folder.service';
import { ActivatedRoute, Router } from '@angular/router';
import { SafeurlPipe } from '../safe-url.pipe';

@Component({
  selector: 'app-folder-details',
  templateUrl: './folder-details.component.html',
  styleUrls: ['./folder-details.component.css']
})
export class FolderDetailsComponent implements OnInit {

  media: any = [];

  constructor(public rest: FolderService, private route: ActivatedRoute, private router: Router) { }
  ngOnInit() {
    this.rest.getMedia(this.route.snapshot.params['id']).subscribe((data: {}) => {
      console.log(data);
      this.media = data;
    });
  }
}
