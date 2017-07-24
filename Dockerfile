FROM alpine:3.4
MAINTAINER Sergey Chikin <sergey.chikin@toptal.com>
ENV ES_VER=5.5.0

RUN apk --update --no-cache add openssl ca-certificates openjdk8-jre 'su-exec>=0.2' bash
WORKDIR /usr/share
RUN wget http://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-$ES_VER.tar.gz -O - | tar xvfz - \
    && mv elasticsearch-$ES_VER elasticsearch && rm -f elasticsearch-$ES_VER.tar.gz

WORKDIR /usr/share/elasticsearch

RUN mkdir -p ./plugins; \
	for path in \
		./data \
		./logs \
		./config \
		./config/scripts \
	; do \
		mkdir -p "$path"; \
	done;

COPY jvm.options /usr/share/elasticsearch/config

RUN addgroup -S elasticsearch && adduser -S -G elasticsearch elasticsearch && chown -R elasticsearch:elasticsearch /usr/share/elasticsearch

ENV PATH /usr/share/elasticsearch/bin:$PATH

VOLUME /usr/share/elasticsearch/data

ADD docker-entrypoint.sh /usr/sbin

EXPOSE 9200 9300
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["elasticsearch"]
