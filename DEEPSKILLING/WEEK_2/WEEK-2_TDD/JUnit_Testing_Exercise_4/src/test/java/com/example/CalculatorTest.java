package com.example;

import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.After;
import org.junit.Test;

public class CalculatorTest {

    private Calculator calculator;

    // Setup: runs before each test
    @Before
    public void setUp() {
        calculator = new Calculator();
        System.out.println("Setup complete");
    }

    // Teardown: runs after each test
    @After
    public void tearDown() {
        System.out.println("Test finished\n");
    }

    @Test
    public void testAddition() {
        // Arrange: done in setUp()

        // Act
        int result = calculator.add(4, 6);

        // Assert
        assertEquals(10, result);
    }

    @Test
    public void testSubtraction() {
        // Arrange: done in setUp()

        // Act
        int result = calculator.subtract(10, 3);

        // Assert
        assertEquals(7, result);
    }
}
