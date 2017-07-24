# Elasticsearch 5.5 unofficial image
## What's inside?
Build the image with `docker build -t <yourtag> .`. Mount persistent volume at /usr/share/elasticsearch/data. Pay attention to FS permissions when using with Kubernetes. The image is based on Alpine Linux for smaller footprint

This repo also contains example single-file Kubernetes definition to run the image on a cluster and an example config
## Why do I use it?
If you ever tried running Elasticsearch from official image on Kubernetes you would probably know the answer. Official image is not flexible for outside modifications. Also, official `elastic.co` 5.5 images are bundled with `X-Pack` which is redundant. This image runs the custom `docker-entrypoint` that copies the config over from */config/elasticsearch.yml* before starting the container. If you want to have a flexible Elasticsearch 5.5 image feel free to use this image

## How do I run it locally?
Run with
`docker run -v <path to config>:/config/elasticsearch.yml -p 9200:9200 schikin/elasticsearch:5.5`
Check that Elasticsearch is running:
`curl http://localhost:9200`

## How do I deploy to Kubernetes?
1. Make sure `kubectl` is pointing at the right cluster
2. Run `kubectl apply -f elasticsearch.yml`

This installs Elasticsearch on a `kube-system` namespace. Best served with *docker-filebeat*, *docker-logstash* and *docker-kibana* for a Kubernetes cluster logging

Make sure you have enough resources on cluster before proceeding. This definition allocates full vCPU to Elasticsearch and 2Gb of RAM (1Gb on-heap and 1Gb for lucene index)
