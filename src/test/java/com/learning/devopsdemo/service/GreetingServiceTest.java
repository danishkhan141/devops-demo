package com.learning.devopsdemo.service;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class GreetingServiceTest {

    @Test
    void shouldReturnGreeting() {
        GreetingService greetingService = new GreetingService();

        String result = greetingService.getGreeting();

        assertEquals("Hello from Spring Boot!", result);
    }
}