FROM bellsoft/liberica-openjre-debian:21-cds AS builder
WORKDIR /builder
ARG JAR_FILE=hwa/target/*.jar
COPY ${JAR_FILE} app.jar
RUN java -Djarmode=tools -jar app.jar extract --layers --destination extracted

FROM bellsoft/liberica-openjre-debian:21-cds AS runner
WORKDIR /app
ARG BUILDER_PATH=/builder/extracted
COPY --from=builder ${BUILDER_PATH}/dependencies/ ./
COPY --from=builder ${BUILDER_PATH}/spring-boot-loader/ ./
COPY --from=builder ${BUILDER_PATH}/snapshot-dependencies/ ./
COPY --from=builder ${BUILDER_PATH}/application/ ./
ENTRYPOINT [ "java", "-jar", "app.jar" ]