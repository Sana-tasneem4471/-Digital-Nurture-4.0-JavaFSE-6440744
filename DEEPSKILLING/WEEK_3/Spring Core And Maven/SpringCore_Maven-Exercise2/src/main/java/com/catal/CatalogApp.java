package com.catal;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import com.catalog.service.CatalogService;

public class CatalogApp {
    public static void main(String[] args) {
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");

        CatalogService service = (CatalogService) context.getBean("catalogService");
        service.addItem("Zero to One");
    }
}
