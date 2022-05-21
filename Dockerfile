FROM openjdk:17-ea-jdk-alpine

RUN mkdir /geyser
RUN mkdir /geyser/data

COPY Geyser.jar /usr/bin/Geyser.jar
COPY config.yml /geyser

WORKDIR /geyser/data
VOLUME /geyser/data

EXPOSE 19132
CMD ["java", "-Xmx512M", "-Xms512M", "-jar", "/usr/bin/Geyser.jar", "--config", "/geyser/config.yml"]