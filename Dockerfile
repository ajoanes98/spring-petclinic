# First stage: build the application using a Maven image
FROM maven:3.8.4-openjdk-17-slim AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml and download the dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the rest of the project files
COPY . .

# Package the application
RUN mvn package -DskipTests

# Second stage: create the final image with the application
FROM openjdk:17

# Set the working directory in the container
WORKDIR /app

# Copy the packaged application from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port 8080 to the outside world
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "app.jar"]

