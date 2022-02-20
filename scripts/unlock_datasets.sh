#!/bin/sh

set -e

SCRIPTS_DIR=$(dirname "$0")

# shellcheck source=../templates/truenas_env.sh.j2
. "$SCRIPTS_DIR/env.sh"

# shellcheck source=./functions.sh
. "$SCRIPTS_DIR/functions.sh"

export TRUENAS_API_TOKEN # export from `$SCRIPTS_DIR/env.sh`

# shellcheck disable=SC2087
ssh -o StrictHostKeyChecking=no root@"$PI_HOST" <<- EOF || echo "Vault already open, skipping..."
    printf "$LUKS_PASS" | cryptsetup open /secure.img vault --key-file -
    mount /dev/mapper/vault /mnt/vault
EOF

TRUENAS_PASSPHRASE=$(ssh -o StrictHostKeyChecking=no root@"$PI_HOST" cat /mnt/vault/truenas_passphrase)
"$SCRIPTS_DIR"/unlock_datasets.py "$TRUENAS_PASSPHRASE"

close_vault
