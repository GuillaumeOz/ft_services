FROM nginx:alpine

RUN apk upgrade --update-cache --available && \
    apk add openssl openssh && \
    rm -rf /var/cache/apk/*

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75/L=Paris/O=42/CN=gozsertt' -keyout /etc/ssl/certs/localhost.key -out /etc/ssl/certs/localhost.crt

COPY files/nginx.conf /etc/nginx/nginx.conf
COPY scripts/start.sh /start.sh
COPY files/index.html /usr/share/nginx/html

COPY files/sshd_config /etc/ssh/

COPY files/ssh_host_dsa_key /etc/ssh
COPY files/ssh_host_rsa_key /etc/ssh

RUN chmod 600 /etc/ssh/ssh_host_*

EXPOSE 22 80 443
#Check the entrypoint success command
ENTRYPOINT sh /start.sh
