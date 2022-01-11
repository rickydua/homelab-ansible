#!/bin/sh

set -xe

# 10 mins timeout
readonly timeout="600"

# Depends on /etc/default/telegraf env file for env vars

i=1
while true; do
    curl --write-out "%{http_code}\n" \
      --silent --output /dev/null \
      --head "http://$INFLUXDB_HOST:8086/ping" > /tmp/response.txt
    
    if [ "$(cat /tmp/response.txt)" = "204" ]; then
        break
    fi

    sleep 1
    echo "Retrying"

    i=$((i+1))
    if [ "$i" -gt "$timeout" ]; then
        echo "TIMEOUT"
        exit 1
    fi
done

echo "Conntected"
/usr/bin/telegraf -config "$TELEGRAPH_CONFIG"
