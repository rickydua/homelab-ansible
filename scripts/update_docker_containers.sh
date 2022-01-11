#!/bin/sh

set -xe

# shellcheck source=../templates/env.sh.j2
. "$HOME/env.sh"

cd "$DOCKER_COMPOSE"
docker-compose pull && docker-compose up -d
