# Stage 1: compile and test the application
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /workspace

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package


# Stage 2: run only the packaged application
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

RUN groupadd --gid 1001 spring \
    && useradd --uid 1001 --gid spring --shell /usr/sbin/nologin spring

COPY --from=build --chown=spring:spring \
    /workspace/target/devops-demo-0.0.1-SNAPSHOT.jar app.jar

USER spring

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "app.jar"]