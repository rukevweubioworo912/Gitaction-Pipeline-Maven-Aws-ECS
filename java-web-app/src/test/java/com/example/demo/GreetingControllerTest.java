package com.example.demo;

import com.example.demo.controller.GreetingController;
import com.example.demo.service.GreetingService;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.beans.factory.annotation.Autowired;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(GreetingController.class)
public class GreetingControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private GreetingService greetingService;

    @Test
    void testGreetEndpoint() throws Exception {
        when(greetingService.greet("Alice")).thenReturn("Hello, Alice!");
        mockMvc.perform(get("/greet?name=Alice"))
               .andExpect(status().isOk())
               .andExpect(content().string("Hello, Alice!"));
    }
}
