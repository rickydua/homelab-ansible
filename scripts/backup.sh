#!/bin/sh

set -xe

# shellcheck source=../templates/env.sh.j2
. "$HOME/env.sh"

restic backup --exclude-file="$HOME/restic/excludes.txt" "$NFS_MOUNTPOINT"
backup_exit_status=$?

curl -m 10 \
  --retry 5 "https://hc-ping.com/40cebfa8-c00c-4f3f-8a19-0c2929d9fe49/$backup_exit_status"
