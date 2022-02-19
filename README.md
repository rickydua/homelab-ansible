# Instructions steps setting/restore up homelab OS (Debian) from scratch

## (Prerequisites)

- Data - Everything that's backed up, excluding ⬇️
  - Downloads
  - pve-disks
  - media/Movies
  - media/TV_Series
- Presumably data should be disk(s) either single or on ZFS raid
- All disks should be passthrough'ed to the truenas OS if running in a VM
- All disks should be passthrough'ed to the truenas OS if running with HBA on metal machine (should be in IT mode)
- Machine ofcource with VM support perferablly
- Raspberrry PI (optional, if you don't want to type passphrase for dataset everytime truenas restarts)
  - Luks container at `/secure.img` with passphrase `***REMOVED***`
  - Dir `/mnt/vault` with `chmod 777`
  - `/mnt/vault/truenas_passphrase` file should exist with no newlines `\n` (use `printf`), which contains passphrase to unlock datasets in truenas

## Steps

### TrueNAS Core Setup

- Install TrueNAS Core
- Make IP static
- Change hostname to `eggs`
- Make sure disks are connected and TrueNAS can see them
- (If you have TrueNAS config file) Import TrueNAS config file
  - Which would import the pool and restore any settings you had
- (If no config file) Import Zpool via the UI
  - `cn$: ansible-playbook eggs-playbook.yml`
  - (Optional) Setup `Periodic Snapshots Tasks` every day, with 1 day retention policy
  - (Optional) Setup `Replication Tasks` same time as snapshot event time, with 7 days retention policy
    - Replicate to local backup pool if you have it set up
  - Setup scrub task every month
  - Setup NFS shares

### TrueNAS Automatic Unlock

If you have setup Raspberry PI with above instructions, you can use it to unlock all passphrase locked datasets.

- Copy TrueNAS machine ssh publicKey to PI host (for passwordless auth)
- Create a task in `Init/Shutdown Scripts` under `Tasks`
- Fill below ⬇️

| Name    | Value                                     |
| ------- | ----------------------------------------- |
| Command | /bin/sh /scripts/unlock_main_bootstrap.sh |
| When    | Post-Init                                 |
| Timeout | 120                                       |
