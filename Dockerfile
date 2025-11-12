FROM eclipse-temurin:21.0.8_9-jdk-jammy AS builder
WORKDIR /opt/app
RUN apt-get update && apt-get install -y maven
COPY hwa/pom.xml .
RUN mvn dependency:go-offline
COPY hwa/src/ ./src
RUN mvn clean install -DskipTests

FROM eclipse-temurin:21.0.8_9-jre-alpine AS final
WORKDIR /opt/app
EXPOSE 8080
COPY --from=builder /opt/app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]