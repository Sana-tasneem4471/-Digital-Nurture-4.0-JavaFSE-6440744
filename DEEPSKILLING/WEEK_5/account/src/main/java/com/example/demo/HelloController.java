package com.example.demo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/account")
    public Account getAccountDetails() {
        return new Account("00987987973432", "savings", 234343);
    }
}
