# Stage 1: Build the application with Maven
FROM maven:3.8-openjdk-11-slim AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and download dependencies (to utilize Docker cache efficiently)
COPY pom.xml .

# Download Maven dependencies
RUN mvn dependency:go-offline

# Copy the source code into the container
COPY src ./src

# Build the application (skip tests for faster build)
RUN mvn clean package -DskipTests

# Stage 2: Run the application in a lightweight image
FROM openjdk:11-jre-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the jar file from the build stage
COPY --from=build /app/target/my-java-app-1.0-SNAPSHOT.jar /app/my-java-app.jar

# Expose the port the app will run on
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "my-java-app.jar"]
