#!/bin/bash

# Create project directories
mkdir -p java-web-app/src/main/java/com/example/demo/controller
mkdir -p java-web-app/src/main/java/com/example/demo/service
mkdir -p java-web-app/src/main/resources
mkdir -p java-web-app/src/test/java/com/example/demo
mkdir -p java-web-app/.github/workflows

# Create DemoApplication.java
cat <<EOL > java-web-app/src/main/java/com/example/demo/DemoApplication.java
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}
EOL

# Create GreetingService.java
cat <<EOL > java-web-app/src/main/java/com/example/demo/service/GreetingService.java
package com.example.demo.service;

import org.springframework.stereotype.Service;

@Service
public class GreetingService {
    public String greet(String name) {
        if (name == null || name.isEmpty()) {
            return "Hello, World!";
        }
        return "Hello, " + name + "!";
    }
}
EOL

# Create GreetingController.java
cat <<EOL > java-web-app/src/main/java/com/example/demo/controller/GreetingController.java
package com.example.demo.controller;

import com.example.demo.service.GreetingService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GreetingController {

    private final GreetingService greetingService;

    public GreetingController(GreetingService greetingService) {
        this.greetingService = greetingService;
    }

    @GetMapping("/greet")
    public String greet(@RequestParam(value = "name", defaultValue = "") String name) {
        return greetingService.greet(name);
    }
}
EOL

# Create GreetingServiceTest.java
cat <<EOL > java-web-app/src/test/java/com/example/demo/GreetingServiceTest.java
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
EOL

# Create GreetingControllerTest.java
cat <<EOL > java-web-app/src/test/java/com/example/demo/GreetingControllerTest.java
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
EOL

# Create pom.xml
cat <<EOL > java-web-app/pom.xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.example</groupId>
    <artifactId>demo</artifactId>
    <version>1.0-SNAPSHOT</version>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.2.0</version>
    </parent>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
EOL

# Create index.html
cat <<EOL > java-web-app/src/main/resources/static/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Greeting App</title>
</head>
<body>
    <h1>Greeting App</h1>
    <input type="text" id="name" placeholder="Enter your name">
    <button onclick="greet()">Greet</button>
    <p id="result"></p>

    <script>
        function greet() {
            const name = document.getElementById("name").value;
            fetch("/greet?name=" + name)
                .then(response => response.text())
                .then(data => document.getElementById("result").innerText = data);
        }
    </script>
</body>
</html>
EOL

# Create GitHub Actions workflow
cat <<EOL > java-web-app/.github/workflows/ci.yml
name: Java CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3
    - name: Set up JDK
      uses: actions/setup-java@v3
      with:
        distribution: 'temurin'
        java-version: '17'
    - name: Build with Maven
      run: mvn clean install
    - name: Run Tests
      run: mvn test
    - name: Run SonarQube Analysis
      uses: sonarsource/sonarcloud-github-action@v2
      with:
        projectKey: 'demo-java-app'
        organization: 'your-org'
        token: \${{ secrets.SONAR_TOKEN }}
EOL

echo "All files created! Navigate to java-web-app/ and run 'mvn spring-boot:run'"
