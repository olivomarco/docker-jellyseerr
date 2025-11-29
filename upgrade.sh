#!/bin/bash

export INT_DOMAIN=$(hostname --fqdn)
export EXT_DOMAIN=$(hostname).olivo.net

cd $(dirname $0)

docker compose -f docker-compose.yml -p jellyseerr down
docker rmi ghcr.io/fallenbagel/jellyseerr:latest
docker compose -f docker-compose.yml -p jellyseerr up -d
