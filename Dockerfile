# syntax=docker/dockerfile:1

FROM openjdk:8u312-jre-buster

LABEL version="9.1.7"
LABEL homepage.group=Minecraft
LABEL homepage.name="The Pixelmon Modpack 9.1.7"
LABEL homepage.icon="https://media.forgecdn.net/avatars/279/234/637276853291457748.png"
LABEL homepage.widget.type=minecraft
LABEL homepage.widget.url=udp://Pixelmon:25565
RUN apt-get update && apt-get install -y curl unzip && \
 adduser --uid 99 --gid 100 --home /data --disabled-password minecraft

COPY launch.sh /launch.sh
RUN chmod +x /launch.sh

USER minecraft

VOLUME /data
WORKDIR /data

EXPOSE 25565/tcp

ENV MOTD " Server"

CMD ["/launch.sh"]