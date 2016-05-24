#!/usr/bin/env bash

eval $(docker-machine env)
docker stop bsimm-graphs
docker rm bsimm-graphs
docker pull diniscruz/bsimm-graphs:latest
docker run --name bsimm-graphs -d -p 127.0.0.1:3000:3000 diniscruz/bsimm-graphs:latest
docker ps
