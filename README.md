**Chamakk E-Commerce Backend Service**
**Overview**

This repository contains the **Spring Boot backend service** for **Chamakk**, a home décor e-commerce platform specializing in premium candles, wax melts, and fragrance products.

The backend is responsible for:

Admin authentication and authorization
Secure JWT-based session management
Product, category, pricing, and inventory management
Database schema ownership and evolution
REST APIs consumed by the Admin Dashboard (frontend)

This service is designed following **industry-standard backend architecture**, suitable for scalable and production-ready deployments.

**Tech Stack
Backend**
Java 17
Spring Boot
Spring Security
JWT Authentication
Hibernate / JPA
Maven

**Database**

PostgreSQL (recommended)
Schema & full backup included

**Security**
JWT Access Tokens
One-session / token management
Secure password handling

**Project Structure**
backend-service/
├── src/main/java/com/chamakk/backend
│   ├── controller        # REST controllers (Admin, Products, etc.)
│   ├── dtos              # Request/Response DTOs
│   ├── model             # JPA entities
│   ├── repository        # Spring Data repositories
│   ├── security          # JWT, filters, security config
│   ├── service           # Business logic
│   └── util              # Utility classes
│
├── src/main/resources
│   └── application.properties
│
├── database
│   ├── chamakk_full_db.sql   # Full DB schema + seed data
│   └── README.md             # DB restore instructions
│
├── pom.xml
└── README.md

**Authentication Flow (Admin)**
Admin logs in using username & password
Backend validates credentials
JWT access token is generated
Token is returned to frontend
Frontend sends token in:
    Authorization: Bearer <JWT_TOKEN>

JwtAuthFilter validates token on every request
This is the same authentication model used by platforms like Amazon, Flipkart, and Myntra admin systems.

**Database Setup**
Create Database
      CREATE DATABASE chamakk_db;

Restore Database
      psql -U postgres -d chamakk_db -f database/chamakk_full_db.sql


Full schema, relations, and base data are included.

**Application Configuration**
application.properties (example)
spring.datasource.url=jdbc:postgresql://localhost:5432/chamakk_db
spring.datasource.username=CHANGE_ME   # add pgadmin 4 username
spring.datasource.password=CHANGE_ME   # add pgadmin 4 password

spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=true

server.port=8080


⚠️ **Never commit real credentials**.
Use environment variables or secrets in production.

**Running the Application**
Prerequisites

Java 17+
Maven
PostgreSQL running

**Run Locally**
mvn clean spring-boot:run

Backend will start at:

http://localhost:8080

**Key Features Implemented**
Admin login & session handling
JWT token generation & validation
Product & variant domain modeling
Category, pricing, stock, and discount entities
Secure Spring Security configuration
Clean layered architecture (Controller → Service → Repository)


**Git & Branching Strategy**
Default branch: main
Feature-based incremental commits
Clean commit history
Database artifacts versioned with backend

**Frontend Integration**
This backend is consumed by:
👉 **Chamakk Admin Frontend (Next.js)**
REST APIs
JWT-based authentication
Role-based access (admin-focused)

**Future Enhancements**
Refresh token flow
Role-based permissions
Order & payment modules
Audit logs
Docker & CI/CD pipelines

**Author**

**Mayuri Nandeshwar**
Senior Java Backend Developer
Nagpur, Maharashtra

License

This project is proprietary and owned by Chamakk.
