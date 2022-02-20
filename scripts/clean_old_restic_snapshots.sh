#!/bin/sh

SCRIPTS_DIR=$(dirname "$0")

# shellcheck source=../templates/truenas_env.sh.j2
. "$SCRIPTS_DIR/env.sh"

export RESTIC_REPOSITORY RESTIC_PASSWORD B2_ACCOUNT_ID B2_ACCOUNT_KEY

# remove old backups
restic forget --keep-daily 7 --keep-weekly 5 --prune

# check integrity of backup
restic check
check_status="$?"

if [ "$check_status" != "0" ]; then
  curl -m 10 \
    --retry 5 "https://hc-ping.com/40cebfa8-c00c-4f3f-8a19-0c2929d9fe49/$check_status"
fi
