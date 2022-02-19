#!/bin/sh

close_vault() {
    # close vault
    ssh -o StrictHostKeyChecking=no root@"$PI_HOST" <<- EOF
        umount /mnt/vault
        cryptsetup close vault
EOF
}
