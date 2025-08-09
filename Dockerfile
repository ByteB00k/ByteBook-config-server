FROM gradle:8.14.2-jdk21-alpine AS builder
WORKDIR /app
COPY gradlew gradlew.bat build.gradle.kts settings.gradle.kts ./
COPY gradle ./gradle
RUN ./gradlew --no-daemon dependencies
COPY src ./src
RUN ./gradlew --no-daemon clean build && rm -rf ~/.gradle/caches

FROM eclipse-temurin:21-jre-alpine-3.22 AS runtime
WORKDIR /app
ARG VERSION
ARG GIT_COMMIT
LABEL org.opencontainers.image.title="ByteB00k Config Server" \
      org.opencontainers.image.description="Handles configurations for application microservices" \
      org.opencontainers.image.version=$VERSION \
      org.opencontainers.image.revision=$GIT_COMMIT \
      org.opencontainers.image.authors="ByteB00k LTD <https://github.com/ByteB00k>" \
      org.opencontainers.image.source="https://github.com/ByteB00k/ByteBook-config-server" \
      org.opencontainers.image.licenses="Proprietary License"
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
COPY --from=builder /app/build/libs/app.jar app.jar
EXPOSE 8882
ENTRYPOINT ["sh", "-c", "export ENCRYPT_KEY=$(cat /run/secrets/encrypt_key) && java -jar app.jar"]
