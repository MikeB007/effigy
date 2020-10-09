package com.effigy.pics;

import java.util.concurrent.atomic.AtomicLong;

import com.effigy.news.searchNews;
import org.json.simple.JSONArray;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PathVariable;


@RestController
public class effigyController {

        private static final String template = "Hello, %s!";
        private final AtomicLong counter = new AtomicLong();

        @GetMapping("/")
        public  String sr(@RequestParam(value = "name", defaultValue = "World") String name) {
                System.out.println("Request");
                return (showResult.getLocations());
        }
        @GetMapping("/table")
        public JSONArray getTables(@RequestParam(value = "table", defaultValue = "World") String table) {
                System.out.println("Request2");
                return (showResult.getTable(table));
        }
        @CrossOrigin
        @GetMapping("/folders")
        public JSONArray getFolders(@RequestParam(value = "table", defaultValue = "World") String table) {
                System.out.println("Request2");
                return (showResult.getFolders());
        }
        @CrossOrigin
        @GetMapping("/folders/{id}")
        public JSONArray getFolderbyID(@PathVariable int id) {
                System.out.println("getting images from folder:" + id);
                return (showResult.getMedia(id));
        }
        @CrossOrigin
        @GetMapping("/years")
        public JSONArray getYears(@RequestParam(value = "table", defaultValue = "World") String table) {
                System.out.println("Request2");
                return (showResult.getYears(0));
        }
        @CrossOrigin
        @GetMapping("/years/{id}")
        public JSONArray getMediabyYear(@PathVariable int id) {
                System.out.println("getting images for  year:" + id);
                return (showResult.getYears(id));
        }
        @CrossOrigin
        @GetMapping("/media/{id}")
        public JSONArray getMediaById(@PathVariable int id) {
                System.out.println("getting media for id:" + id);
                return (showResult.getSingleMedia(id));
        }

        //This
        @CrossOrigin
        @GetMapping("/mediaName/{name}")
        public JSONArray getMediaeByName(@PathVariable String name) {
                System.out.println("getting meida by the name:" + name);
                return (showResult.getSingleMedia(name));
        }

        //This
        @CrossOrigin
        @GetMapping("/timeline")
        public JSONArray getTimelineFull() {
                System.out.println("get full timeline");
                return (showResult.getTimeline(0));
        }
        //This
        @CrossOrigin
        @GetMapping("/timeline/{id}")
        public JSONArray getTimelineByYearID(@PathVariable int id) {
                System.out.println("getting timeline by the year or all:" + id);
                return (showResult.getTimeline(id));
        }
        //This
        @CrossOrigin
        @GetMapping("/timeline/{year}/{month}")
        public JSONArray getTimelineByYear(@PathVariable int year, @PathVariable int month) {
                System.out.println("getting timeline by the year month:");
                return (showResult.getTimelinebyYYYYMM(year, month));
        }

        // ******************  NEWS  ************************
        @CrossOrigin
        @GetMapping("/news/search/{value}")
        public JSONArray getNewsSearch(@PathVariable String value) {
                System.out.println("getting news by Keyword");
                return (searchNews.getLNewsLabels(value));

        }
        @CrossOrigin
        @GetMapping("/news/search/{value}/details")
        public JSONArray getNewsSearchDetails(@PathVariable String value) {
                System.out.println("getting news by Keyword");
                return (searchNews.getLNewsDetails(value));

        }
        @CrossOrigin
        @GetMapping("/news")
        public JSONArray getNewsDefault() {
                System.out.println("getting lates news");
                return (searchNews.getLatestNews(0));
        }
        @CrossOrigin
        @GetMapping("/news/help")
        public String getNewsHelp() {
                System.out.println("Help");
                return (searchNews.getNewsHelp(0));
        }
        @CrossOrigin
        @GetMapping("/news/headlines")
        public JSONArray getNewsHeadlines() {
                System.out.println("getting lates news");
                return (searchNews.getLatestNewsHeadlines(0));
        }
        @CrossOrigin
        @GetMapping("/news/latest")
        public JSONArray getNewsLatest() {
                System.out.println("getting lates news");
                return (searchNews.getLatestNews(0));
        }
        @CrossOrigin
        @GetMapping("/news/latest/{period}")
        public JSONArray getNewsLatest(@PathVariable int period) {
                System.out.println("getting news by Keyword");
                return (searchNews.getLatestNews(period));

        }
        @CrossOrigin
        @GetMapping("/news/latest/source/{src}")
        public JSONArray getNewsLatestStats(@PathVariable String src) {
                System.out.println("getting news by source");
                return (searchNews.getLatestNewsBySource(src));
        }
        @CrossOrigin
        @GetMapping("/news/stats")
        public JSONArray getNewsLatestStats() {
                System.out.println("getting news by Keyword");
                return (searchNews.getLatestNewsStats(0));
        }
        @CrossOrigin
        @GetMapping("/news/stats/{period}")
        public JSONArray getNewsLatestStats(@PathVariable int period) {
                System.out.println("getting news by Keyword");
                return (searchNews.getLatestNewsStats(period));

        }

}
