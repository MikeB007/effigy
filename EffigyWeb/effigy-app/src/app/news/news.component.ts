import { Component, OnInit } from '@angular/core';
import { NewsService } from '../news.service';
import { ActivatedRoute, Router } from '@angular/router';

@Component({
  selector: 'app-news',
  templateUrl: './news.component.html',
  styleUrls: ['./news.component.css']
})
export class NewsComponent implements OnInit {

  news: any = [];

  constructor(public rest: NewsService, private route: ActivatedRoute, private router: Router) { }

  ngOnInit() {
    this.getNews();
  }

  getNews() {
    this.news = [];
    this.rest.getNews().subscribe((data: {}) => {
      console.log(data);
      this.news = data;
    });
  }
}
