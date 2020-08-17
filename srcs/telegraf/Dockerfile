FROM	alpine:latest

RUN	apk add curl ; \
	apk add openrc

RUN	mkdir /etc/telegraf 

RUN	wget https://dl.influxdata.com/telegraf/releases/telegraf-1.14.0-static_linux_amd64.tar.gz ; \
	tar -C . -xvf telegraf-1.14.0-static_linux_amd64.tar.gz ; \
	chmod +x telegraf/* ; \
        cp telegraf/telegraf /usr/bin/ ; \
        rm -rf *.tar.gz* telegraf

COPY telegraf.conf etc/telegraf/telegraf.conf	

EXPOSE	8125

CMD	/usr/bin/telegraf