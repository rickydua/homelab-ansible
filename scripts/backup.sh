#!/bin/sh

set -e

SCRIPTS_DIR=$(dirname "$0")

# shellcheck source=../templates/truenas_env.sh.j2
. "$SCRIPTS_DIR/env.sh"

export RESTIC_REPOSITORY RESTIC_PASSWORD B2_ACCOUNT_ID B2_ACCOUNT_KEY

restic backup --exclude-file="$RESTIC_DIRECTORY/excludes.txt" "$MOUNTPOINT"

backup_exit_status=$?

curl -m 10 \
  --retry 5 "https://hc-ping.com/40cebfa8-c00c-4f3f-8a19-0c2929d9fe49/$backup_exit_status"

"$SCRIPTS_DIR/clean_old_restic_snapshots.sh"
