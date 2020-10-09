import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { HttpClientModule } from '@angular/common/http';

import { AppRoutingModule } from './app-routing.module';

import { AppComponent } from './app.component';
import { FoldersComponent } from './folders/folders.component';


import { RouterModule, Routes } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { FolderDetailsComponent } from './folder-details/folder-details.component';

import { SafeurlPipe } from './safe-url.pipe';
import { YearsComponent } from './years/years.component';
import { YearsDetailsComponent } from './years-details/years-details.component';
import { MediaPlayerComponent } from './media-player/media-player.component';
import { TimelineComponent } from './timeline/timeline.component';
import { TimelineDetailsComponent } from './timeline-details/timeline-details.component';

const appRoutes: Routes = [
  {
    path: 'folders',
    component: FoldersComponent,
    data: { title: 'Folder List' }
  },
  {
    path: 'folders/:id',
    component: FolderDetailsComponent,
    data: { title: 'Folder Details' }
  },
  {
    path: 'years',
    component: YearsComponent,
    data: { title: 'Year List' }
  },
  {
    path: 'years/:id',
    component: YearsDetailsComponent,
    data: { title: 'Year Details' }
  },
  {
    path: 'media/:id',
    component: MediaPlayerComponent,
    data: { title: 'Showing movie' }
  },
  {
    path: 'timeline/:id',
    component: TimelineComponent,
    data: { title: 'Showing Full timeline' }
  },
  {
  path: 'timeline',
  component: TimelineComponent,
  data: { title: 'Showing timeline' }
  },
  {
    path: 'timeline/:id/:id2',
    component: TimelineDetailsComponent,
    data: { title: 'Showing Specific details by Year Month' }
  },

];

@NgModule({
  declarations: [
    AppComponent,
    FoldersComponent,
    FolderDetailsComponent,
    SafeurlPipe,
    YearsComponent,
    YearsDetailsComponent,
    MediaPlayerComponent,
    TimelineComponent,
    TimelineDetailsComponent,
  ],
  imports: [
    RouterModule.forRoot(appRoutes),
    FormsModule,
    BrowserModule,
    HttpClientModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }

