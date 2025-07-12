package com.cognizant.spring_rest_handson4;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class SpringRestHandson4Application {
    private static final Logger LOGGER = LoggerFactory.getLogger(SpringRestHandson4Application.class);
	private static ApplicationContext context2;

    public static void main(String[] args) {
        displayCountry();
        System.out.println("Loading country bean...");

    }

    public static void displayCountry() {
        LOGGER.info("Loading country bean...");
        context2 = new ClassPathXmlApplicationContext("country.xml");
        Country country = context2.getBean("country", Country.class);
        LOGGER.debug("Country: {}", country.toString());
    }
}