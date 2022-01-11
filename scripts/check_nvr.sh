#!/bin/sh
set -e

curl -Lfs -m 10 --retry 2 -o /dev/null http://192.168.100.156:8081
