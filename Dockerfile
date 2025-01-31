FROM maven:3.6.3-openjdk-8 as builder
# Base image with jdk 8 and maven

# Copy our pom.xml and our source-code
COPY mvnw mvnw
COPY mvnw.cmd mvnw.cmd
COPY .mvn .mvn
COPY pom.xml pom.xml
COPY src/ src/

# Build our application
#tes

RUN mvn clean package

# As a separate stage, to save on resulting image size, we discard everything from previous stages
FROM java:8 as runner

# Expose port 8080 for our web-app
EXPOSE 8080

# Copy the jar file from our previous stag
COPY --from=builder target/project1-0.0.1-SNAPSHOT.jar ikenos-teamos.jar

# Run our program
ENTRYPOINT [ "java", "-jar", "ikenos-teamos.jar" ]