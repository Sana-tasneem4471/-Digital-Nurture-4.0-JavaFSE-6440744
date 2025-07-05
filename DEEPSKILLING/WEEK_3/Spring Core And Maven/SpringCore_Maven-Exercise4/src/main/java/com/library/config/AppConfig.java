package com.library.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@ComponentScan(basePackages = "com.library")
public class AppConfig {
    // Spring will scan com.library.* for @Component, @Service, etc.
}
