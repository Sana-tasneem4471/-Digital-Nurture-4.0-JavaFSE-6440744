package com.example;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

public class MyServiceTest {

    @Test
    public void testVerifyInteraction() {
        // Step 1: Create a mock of ExternalApi
        ExternalApi mockApi = Mockito.mock(ExternalApi.class);

        // Step 2: Inject the mock into MyService
        MyService service = new MyService(mockApi);

        // Step 3: Call the method we want to test
        service.fetchData();

        // Step 4: Verify that mockApi.getData() was called
        verify(mockApi).getData();
    }
}
