# Configuration Server

*Provides centralized configuration management for microservices in distributed applications.*

[![Build and Push to Docker Hub](https://github.com/ByteB00k/ByteBook-config-server/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/ByteB00k/ByteBook-config-server/actions/workflows/docker-publish.yml)

## Overview

- [Tech Stack](#tech-stack)
- [Client Service Setup](#client-service-setup)
  - [Configuration File](#configuration-file)
  - [Encryption Endpoints](#encryption-endpoints)
- [Profile Activation Methods](#profile-activation-methods)
- [Getting Started](#getting-started)
  - [1. Running via docker-compose.yml](#1-running-via-docker-composeyml)
  - [2. Running via JAR File](#2-running-via-jar-file)

### Tech Stack

- Java 21
- Spring Boot 3.5
- Gradle 8.14
- Spring Cloud Version 2025.0.0
- Spring Boot Actuator
- [Git backend for configuration storage](https://github.com/ByteB00k/Bytebook-config-repo)

### Client Service Setup

#### Configuration File

Required `application.yml` configuration for client services:

```yaml
spring:
  application:
    name: client-service # Service ID for config lookup
  config:
    import:
      - configserver:http://localhost:8882/ # Config Server endpoint
```

#### Encryption Endpoints

To enable cryptographic endpoints:

1. Add the spring-dotenv dependency to your project:

**Maven:**
```xml
<dependency>
    <groupId>me.paulschwarz</groupId>
    <artifactId>spring-dotenv</artifactId>
    <version>4.0.0</version>
</dependency>
```

**Gradle (Groovy):**
```groovy
implementation 'me.paulschwarz:spring-dotenv:4.0.0'
```

**Gradle (Kotlin):**
```kotlin
implementation("me.paulschwarz:spring-dotenv:4.0.0")
```

2. Create a `.env` file in the project root:

```bash
touch .env
```

3. Add the `ENCRYPT_KEY` secret:

```bash
echo "ENCRYPT_KEY=your-secret-key" >> .env
```

4. Add the `.env` to `.gitignore`:

```bash
echo ".env" >> .gitignore
```

Once configured, you can access the encrypt/decrypt endpoints:

```bash
# Encrypt a value
curl -X POST http://config-server:8882/encrypt -d "password"

# Decrypt a value
curl -X POST http://config-server:8882/decrypt -d "65fa5ba164977153..."
```

### Profile Activation Methods

Profile activation approaches:

1. **Via Environment Variables/JVM Flags**

IntelliJ IDEA (Run Configuration):

```text
VM Options: -Dspring.profiles.active=dev
```

Command Line:

```bash
java -jar app.jar --spring.profiles.active=dev
```

2. **Docker Environment**

Dockerfile:

```dockerfile
ENV SPRING_PROFILES_ACTIVE=dev
```

docker-compose.yml:

```yaml
services:
  config-server:
    environment:
      - SPRING_PROFILES_ACTIVE=dev
```

Container launch:

```bash
docker run -e "SPRING_PROFILES_ACTIVE=dev" image-name
```

3. **Configuration Files**

application.yml/bootstrap.yml:

```yaml
spring:
  profiles:
    active: dev
```

### Getting Started

#### 1. Running via docker-compose.yml

[Check the latest version](https://hub.docker.com/repository/docker/roman3455/bytebook-config-server/general) and add it
to your `docker-compose.yml`:
```yaml
services:
  config-server:
    image: roman3455/bytebook-config-server:latest-tag
    container_name: bytebook-config-server
    ports:
      - "8882:8882"
    environment:
      ENCRYPT_KEY: ${ENCRYPT_KEY}
```

#### 2. Running via JAR File

- Clone the repository:
```bash
git clone https://github.com/ByteB00k/ByteBook-config-server.git
cd ByteBook-config-server
```

- Build the application:
```bash
./gradlew clean build
```

- Run the JAR file (default port **8882**):
```bash
java -jar build/libs/app.jar
```

- Check the health status (in another terminal):

```bash
curl http://localhost:8882/actuator/health
```
