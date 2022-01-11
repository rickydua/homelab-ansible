#!/bin/sh

# shellcheck source=../templates/env.sh.j2
. "$HOME/env.sh"

# remove old backups
restic forget --keep-daily 7 --keep-weekly 5 --keep-monthly 12 --keep-yearly 2 --prune

# Linux `bash` specific
raw_random=$(head -n 200 /dev/urandom | cksum | cut -f 1 -d " ")
random_group="$(( raw_random % 100 ))"

# check integrity of backup
restic check --read-data-subset="$random_group/100"
check_status="$?"

if [ "$check_status" != "0" ]; then
  curl -m 10 \
    --retry 5 "https://hc-ping.com/40cebfa8-c00c-4f3f-8a19-0c2929d9fe49/$check_status"
fi
