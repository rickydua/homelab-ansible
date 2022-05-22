#!/bin/sh

set -xe

cd "$DOCKER_COMPOSE"
/usr/local/bin/docker-compose pull && /usr/local/bin/docker-compose up -d
