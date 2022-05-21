FROM openjdk:17-ea-jdk-alpine

RUN mkdir /geyser
RUN mkdir /geyser/data

COPY downloads/geyser.jar /usr/bin/geyser.jar
COPY config.yml /geyser

WORKDIR /geyser/data
VOLUME /geyser/data

EXPOSE 19132
CMD ["java", "-Xmx512M", "-Xms512M", "-jar", "/usr/bin/geyser.jar", "--config", "/geyser/config.yml"]