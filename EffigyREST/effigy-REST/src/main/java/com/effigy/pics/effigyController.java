package com.effigy.pics;

import java.util.concurrent.atomic.AtomicLong;

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
        @GetMapping("/mediaID/{id}")
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
        public JSONArray getTimelineByYear(@PathVariable int id) {
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
}
