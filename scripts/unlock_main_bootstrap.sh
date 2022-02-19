#!/bin/sh

set -xe

SCRIPTS_DIR=$(dirname "$0")

# shellcheck source=./functions.sh
. "$SCRIPTS_DIR/functions.sh"

"$SCRIPTS_DIR/unlock_datasets.sh" > "$SCRIPTS_DIR/log" 2>&1 || close_vault