package com.catalog.service;

import com.catalog.repository.CatalogRepository;

public class CatalogService {
    private CatalogRepository catalogRepository;

    // Setter Injection
    public void setCatalogRepository(CatalogRepository catalogRepository) {
        this.catalogRepository = catalogRepository;
    }

    public void addItem(String itemName) {
        System.out.println("Adding item: " + itemName);
        catalogRepository.saveItem(itemName);
    }
}
