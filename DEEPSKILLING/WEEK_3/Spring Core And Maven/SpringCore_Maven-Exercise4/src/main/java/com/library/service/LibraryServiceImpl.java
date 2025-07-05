package com.library.service;

import org.springframework.stereotype.Service;

@Service
public class LibraryServiceImpl implements LibraryService {
    @Override
    public void displayLibraryInfo() {
        System.out.println("Welcome to the Spring-based Library Management System!");
    }
}
