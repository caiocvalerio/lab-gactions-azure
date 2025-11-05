FROM alpine:latest  AS builder
RUN apk update && apk add --no-cache openjdk21
WORKDIR /builder
ARG JAR_FILE=api/target/hwa-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} app.jar
RUN java -Djarmode=tools -jar app.jar extract --layers --destination extracted

FROM alpine:latest  AS runner
RUN apk update && apk add --no-cache openjdk21
WORKDIR /app
ARG BUILDER_PATH=/builder/extracted
COPY --from=builder ${BUILDER_PATH}/dependencies/ ./
COPY --from=builder ${BUILDER_PATH}/spring-boot-loader/ ./
COPY --from=builder ${BUILDER_PATH}/snapshot-dependencies/ ./
COPY --from=builder ${BUILDER_PATH}/application/ ./
ENTRYPOINT [ "java", "-jar", "app.jar" ]