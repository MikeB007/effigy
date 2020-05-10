import { Component, OnInit } from '@angular/core';
import { FolderService } from '../folder.service';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-folders',
  templateUrl: './folders.component.html',
  styleUrls: ['./folders.component.css']
})
export class FoldersComponent implements OnInit {

  folders: any = [];

  constructor(public rest: FolderService, private route: ActivatedRoute, private router: Router) { }

  ngOnInit() {
    this.getFolders();
  }

  getFolders() {
    this.folders = [];
    this.rest.getFolders().subscribe((data: {}) => {
      console.log(data);
      this.folders = data;
    });
  }
}
