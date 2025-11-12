# Start from an official JDK image
FROM amazoncorretto:17-alpine

# Set working directory
WORKDIR /app

# Copy JAR from Maven target folder
COPY target/sampledockerimage-1.0-SNAPSHOT.jar app.jar

# Run the JAR
ENTRYPOINT ["java", "-jar", "app.jar"]

