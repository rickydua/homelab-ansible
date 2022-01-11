#!/bin/sh

echo url="https://www.duckdns.org/update?domains=rickyd&token=49bf08dc-e09d-4712-babf-c76b78b186ef&ip=" | curl -k -o ~/duck.log -K -
