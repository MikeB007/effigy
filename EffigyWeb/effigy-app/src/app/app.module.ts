import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { HttpClientModule } from '@angular/common/http';

import { AppRoutingModule } from './app-routing.module';

import { AppComponent } from './app.component';
import { FoldersComponent } from './folders/folders.component';


import { RouterModule, Routes } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { FolderDetailsComponent } from './folder-details/folder-details.component';

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
  }
];

@NgModule({
  declarations: [
    AppComponent,
    FoldersComponent,
    FolderDetailsComponent,
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

