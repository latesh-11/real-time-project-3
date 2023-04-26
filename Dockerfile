FROM maven as build
WORKDIR /app
COPY . .
RUN mvn install

#----------STAGE 2nd-------#

FROM openjdk:8-jdk-alpine
WORKDIR /app
COPY --from=build app/targate/*.jar /app/
CMD [ "java" , "-jar" , "app.jar" ]