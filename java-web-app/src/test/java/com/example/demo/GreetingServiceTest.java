package com.example.demo;

import com.example.demo.service.GreetingService;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class GreetingServiceTest {

    private final GreetingService service = new GreetingService();

    @Test
    void testGreetWithName() {
        assertEquals("Hello, Alice!", service.greet("Alice"));
    }

    @Test
    void testGreetWithoutName() {
        assertEquals("Hello, World!", service.greet(""));
    }
}
