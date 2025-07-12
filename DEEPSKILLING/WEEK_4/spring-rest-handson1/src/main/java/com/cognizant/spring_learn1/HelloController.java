package com.cognizant.spring_learn1;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
@RestController  // <-- You MUST add this
public class HelloController {
	 @GetMapping("/")
	    public String hello() {
	        return "Welcome to Spring Learn!";
	    }
	}

