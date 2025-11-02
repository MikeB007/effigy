# Effigy REST API

This is a Spring Boot application that provides REST API services for news, pictures/media, and trade view functionality.

## Quick Start

### Building the Application
```bash
# Clean build
.\mvnw.cmd clean compile

# Run tests
.\mvnw.cmd test

# Create deployment package
.\mvnw.cmd package -Pdist
```

### Running the Application
```bash
# Run locally
.\mvnw.cmd spring-boot:run

# Run with specific profile
.\mvnw.cmd spring-boot:run -Dspring.profiles.active=dev
```

### Deployment
After building with `-Pdist` profile, deployment packages are created in:
- `deployment/dist/effigy-rest-deployment-package-0.0.1-SNAPSHOT.zip`

For detailed deployment instructions, see `deployment/README.md`.

### Project Structure
```
effigy-REST/
├── src/main/java/com/effigy/
│   ├── news/           # News functionality
│   ├── pics/           # Pictures/media functionality
│   └── tradeview/      # Trade view functionality
├── deployment/         # Deployment configurations and scripts
│   ├── dist/          # Final deployment packages
│   └── staging/       # Temporary build artifacts (auto-cleaned)
└── docs/              # Project documentation
```

### Improvements
See `PROJECT-IMPROVEMENTS.md` for detailed project structure improvements and recommendations.

## Reference Documentation
For further reference, please consider the following sections:

* [Official Apache Maven documentation](https://maven.apache.org/guides/index.html)
* [Spring Boot Maven Plugin Reference Guide](https://docs.spring.io/spring-boot/docs/3.4.0/maven-plugin/)
* [Spring Web](https://docs.spring.io/spring-boot/docs/3.4.0/reference/htmlsingle/#boot-features-developing-web-applications)

## Guides
The following guides illustrate how to use some features concretely:

* [Building a RESTful Web Service](https://spring.io/guides/gs/rest-service/)
* [Serving Web Content with Spring MVC](https://spring.io/guides/gs/serving-web-content/)
* [Building REST services with Spring](https://spring.io/guides/tutorials/bookmarks/)
* [Accessing data with MySQL](https://spring.io/guides/gs/accessing-data-mysql/)

