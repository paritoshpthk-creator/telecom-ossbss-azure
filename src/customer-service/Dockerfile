FROM eclipse-temurin:17-jre

WORKDIR /app

COPY src/customer-service/target/customer-service-1.0.0.jar app.jar

EXPOSE 8082

ENTRYPOINT ["java", "-jar", "app.jar"]
