FROM openjdk

RUN mkdir /bot
COPY ./botconfig.txt /bot/config.txt
COPY ./botconfig_secrets.txt /bot/botconfig_secrets.txt
RUN cat /bot/botconfig_secrets.txt >> /bot/config.txt
RUN rm /bot/botconfig_secrets.txt

WORKDIR /bot
RUN curl -L -o jmusicbot.jar https://github.com/jagrosh/MusicBot/releases/download/0.3.6/JMusicBot-0.3.6.jar

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

