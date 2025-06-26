package com.example;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

public class MyServiceTest {

    @Test
    public void testExternalApi() {
        // Step 1: Create a mock of ExternalApi
        ExternalApi mockApi = Mockito.mock(ExternalApi.class);

        // Step 2: Stub the method getData() to return a predefined value
        when(mockApi.getData()).thenReturn("Mock Data");

        // Step 3: Inject the mock into MyService
        MyService service = new MyService(mockApi);

        // Step 4: Call the method we are testing
        String result = service.fetchData();

        // Step 5: Verify the result using assertions
        assertEquals("Mock Data", result);
    }
}
