# Configuration Server

*Provides centralized configuration management for microservices in distributed applications.*

- [Tech Stack](#tech-stack)
- [Key Features](#key-features)
- [Architecture Overview](#architecture-overview)
- [Client Service Setup](#client-service-setup)
- [Profile Activation Methods](#profile-activation-methods)
- [Getting Started](#getting-started)
  - [1. Running via JAR File](#1-running-via-jar-file)

### Tech Stack

- Java 21
- Spring Boot 3.5
- Gradle 8.14
- Spring Cloud Version 2025.0.0
- Spring Boot Actuator
- [Git backend for configuration storage](https://github.com/ByteB00k/Bytebook-config-repo)

### Key Features

- **Versioned Configuration**: All configurations stored in Git with full history
- **Environment Profiles**: Supports dev/test/stage/prod environments
- **Sensitive Data Protection**: Built-in encryption/decryption endpoints
- **Operational Visibility**: Actuator health checks

### Architecture Overview

```mermaid
graph TD
    subgraph Config Storage
        G[Git Repository]
    end

    subgraph Config Server
        CS[Spring Cloud Config Server]
    end

    subgraph Client Services
        S1[Service 1]
        S2[Service 2]
        S3[Service ...]
    end

    G -->|Config Fetch| CS
    CS -->|Configuration| S1
    CS -->|Configuration| S2
    CS -->|Configuration| S3

    style G fill:#F05032,color:white
    style CS fill:#6DB33F,color:white
    style S1 fill:#4285F4,color:white
    style S2 fill:#4285F4,color:white
    style S3 fill:#4285F4,color:white
```

```mermaid
sequenceDiagram
    participant Client as Client Service
    participant Config as Config Server
    participant Git as Git Repo

    Client->>Config: Request config (on startup)
    Config->>Git: Fetch configuration
    Git-->>Config: Return config files
    Config-->>Client: Merged configuration
```

### Client Service Setup

Minimal `application.yml` configuration for client services:

```yaml
spring:
  application:
    name: client-service # Service ID for config lookup
  config:
    import:
      - configserver:http://localhost:8071 # Config Server endpoint
```

### Profile Activation Methods

Spring Cloud Config supports multiple profile activation approaches:

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

#### 1. Running via JAR File

- Clone the repository:

```bash
git clone https://github.com/ByteB00k/ByteBook-config-server.git
cd ByteBook-config-server
```

- Build the application:

```bash
./gradlew clean build
```

- Run the JAR file (default port 8882) with custom profile:

```bash
java -Dspring.profiles.active=dev -jar build/libs/app.jar
```

- Verify (in another terminal):

```bash
curl http://localhost:8888/actuator/health
```