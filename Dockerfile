# This Dockerfile is used to build a Docker image for the Parcel Search application.

FROM eclipse-temurin:21-jre as builder
WORKDIR application
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} application.jar
RUN java -Djarmode=layertools -jar application.jar extract

FROM eclipse-temurin:21-jre
WORKDIR application
COPY --from=builder application/dependencies/ ./
COPY --from=builder application/spring-boot-loader/ ./
COPY --from=builder application/snapshot-dependencies/ ./
COPY --from=builder application/application/ ./
ENTRYPOINT ["java", "-jar", "/app.jar"]

# The JarLauncher class has been relocated to a new package since Spring Boot 3.2.0.