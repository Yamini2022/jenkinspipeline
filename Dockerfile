# Use an OpenJDK base
FROM eclipse-temurin:17-jre-alpine

ARG JAR_FILE=target/simple-maven-app-1.0.0.jar
COPY ${JAR_FILE} /app/app.jar

ENTRYPOINT ["java","-jar","/app/app.jar"]
