FROM openjdk:17-ea-jdk

RUN microdnf update && \
    microdnf install curl

# add the files
RUN mkdir /geyser
RUN mkdir /geyser/data
COPY geyser/config.yml /geyser
COPY geyser/geyser.sh /geyser
RUN chmod +x /geyser/geyser.sh

WORKDIR /geyser/data
VOLUME /geyser

ENV PORT=19132
EXPOSE $PORT/udp

ENTRYPOINT [ "sh", "/geyser/geyser.sh" ]