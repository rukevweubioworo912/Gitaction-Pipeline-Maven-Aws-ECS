
FROM openjdk:17-jdk-slim


WORKDIR /app

 COPY target/*.jar app.jar   

# Expose port 8080
EXPOSE 8080             




# Run the JAR file
ENTRYPOINT ["java","-jar","app.jar"]
