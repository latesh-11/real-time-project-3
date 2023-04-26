FROM maven as build
WORKDIR /app
COPY . .

#----------STAGE 2nd-------#

FROM openjdk:8-jdk-alpine
WORKDIR /app
COPY --from=build ./targate/*.jar /app/
CMD [ "java" , "-jar" , "app.jar" ]