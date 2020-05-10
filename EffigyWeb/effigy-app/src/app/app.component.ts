import { Component } from '@angular/core';
import {DomSanitizer} from '@angular/platform-browser';
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  constructor(private sanitizer: DomSanitizer){}
  sanitizedUrl;
  ngOnInit(){
    this.sanitizedUrl = this.sanitizer.bypassSecurityTrustUrl('Notes://MYSERVER/C1256D3B004057E8');
  }
  sanitize(url: string){
    return this.sanitizer.bypassSecurityTrustUrl(url);
  }
}
