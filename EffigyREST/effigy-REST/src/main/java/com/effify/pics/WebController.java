package com.effify.pics;

import java.util.concurrent.atomic.AtomicLong;

import com.effify.pics.showResult;
import org.json.simple.JSONArray;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.jws.WebService;
import javax.servlet.annotation.WebServlet;
import java.sql.ResultSet;



@WebServlet
public class WebController {

        private static final String template = "Hello, %s!";
        private final AtomicLong counter = new AtomicLong();

        @GetMapping("/web")
        public String sr(@RequestParam(value = "name", defaultValue = "World") String name) {
            return ("web");
        }

}
