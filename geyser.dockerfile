FROM openjdk:17-ea-jdk-alpine

# Download latest version of the GeyserMC
ADD https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/standalone/build/libs/Geyser-Standalone.jar /usr/bin/

# add the config file
RUN mkdir /geyser
RUN mkdir /data
COPY geyser/config.yml /geyser/config.yml

WORKDIR /geyser/data
VOLUME /geyser

ENV PORT=19132
EXPOSE $PORT/udp

CMD ["java", "-Xmx512M", "-Xms512M", "-jar", "/usr/bin/Geyser-Standalone.jar", "--config", "/geyser/config.yml"]