package com.example;

public class MyService {
    private ExternalApi api;

    // Constructor Injection
    public MyService(ExternalApi api) {
        this.api = api;
    }

    public String fetchData() {
        return api.getData();  // Calls external API (mocked in test)
    }
}
