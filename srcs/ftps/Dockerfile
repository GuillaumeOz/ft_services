
FROM alpine:latest

RUN apk upgrade && \
    printf '%s\n' \
      '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' \
      >> /etc/apk/repositories && \
    apk update && \
    apk add pure-ftpd@testing="1.0.49-r1" && \
    rm -rf /var/cache/apk/*

COPY files/pure-ftpd.pem /etc/ssl/private/
COPY scripts/start-tmp.sh /bin/start-tmp.sh

ENTRYPOINT ["/bin/start-tmp.sh"]