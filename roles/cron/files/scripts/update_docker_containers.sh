#!/bin/sh

set -xe

cd "$DOCKER_COMPOSE"
docker-compose pull && docker-compose up -d
