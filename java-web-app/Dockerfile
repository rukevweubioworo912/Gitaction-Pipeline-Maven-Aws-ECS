# Use OpenJDK 17 slim image
FROM openjdk:17-jdk-slim

# Set working directory inside the container
WORKDIR /app

# Copy the built JAR from the target folder
COPY target/demo-1.0-SNAPSHOT.jar app.jar
# Expose the port that Spring Boot uses
EXPOSE 8080

# Optional: set environment variable for Spring Boot port
ENV SERVER_PORT=8080

# Run the Spring Boot JAR
ENTRYPOINT ["java", "-jar", "app.jar"]
