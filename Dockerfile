FROM alpine:latest

RUN apk add s3cmd

COPY entrypoint.sh /
COPY dobackups.sh /

RUN chmod +x /entrypoint.sh /dobackups.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "crond", "-f", "-d", "8" ]