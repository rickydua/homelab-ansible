#!/bin/sh

set -xe
# requires root

# --force doesnt ask for promt
docker container prune --force
docker image prune --all --force
