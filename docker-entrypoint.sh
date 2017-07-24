#!/bin/bash
set -e
# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- elasticsearch "$@"
fi

if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
	# Change the ownership of user-mutable directories to elasticsearch
	for path in \
		/usr/share/elasticsearch/data \
		/usr/share/elasticsearch/logs \
	; do
		chown -R elasticsearch:elasticsearch "$path"
	done

	set -- su-exec elasticsearch "$@"
	#exec su-exec elasticsearch "$BASH_SOURCE" "$@"
fi

if [ "$1" = 'elasticsearch' ]; then
	set -- su - elasticsearch -s /bin/sh -c elasticsearch -- "$@"
fi

if [ -f '/config/elasticsearch.yml' ]; then
	cp -f /config/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
	echo 'copied config file'
fi

exec "$@"
