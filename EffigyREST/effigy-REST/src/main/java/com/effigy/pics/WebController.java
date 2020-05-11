package com.effigy.pics;

import java.util.concurrent.atomic.AtomicLong;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.annotation.WebServlet;


@WebServlet
public class WebController {

        private static final String template = "Hello, %s!";
        private final AtomicLong counter = new AtomicLong();

        @GetMapping("/web")
        public String sr(@RequestParam(value = "name", defaultValue = "World") String name) {
            return ("web");
        }

}
