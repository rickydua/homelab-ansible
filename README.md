# Instructions on setting/restoring Homelab from scratch

## Setting up control node

<details>
  <summary>Click to setup up control node</summary>
If you need to setup up a new control node from scratch (new laptop maybe)

### Requirements

- [taskfile](https://taskfile.dev/#/installation), `python3` and `pip3` should be installed
- Python user `bin` directory should be in `PATH`
  - For MacOS path is `~/Library/Python/{python version}/bin`

### Steps

- ```sh
  git clone git@github.com:rickydua/homelab-ansible.git && \
  cd homelab-ansible && \
  task bootstrap
  ```
- Generate ssh key pair and copy public key to all [hosts](inventory/hosts.yml) for password-less auth
- Create or validate `~/.ansible/vault_pass` ansible vault with passphrase already setup
- Confirm with `ansible all -m ping`
</details>

## Prerequisites

- Data - Everything that's backed up, excluding [these paths](templates/excludes.txt.j2)
- Presumably data should be on a single ZFS disk or on ZFS raid
- All disks should be passthrough'ed to the truenas OS if running in a VM
- All disks should be passthrough'ed to the truenas OS if running with HBA on metal machine (should be in IT mode)
- 2 boxes (either VM or physical doesn't matter)
  - TrueNAS box
  - chicken debian host aka docker host
- Raspberry PI (optional, if you don't want to type passphrase for dataset every time truenas restarts)
  - Luks container at `/secure.img` with passphrase
  - Dir `/mnt/vault` with `chmod 777`
  - `/mnt/vault/truenas_passphrase` file should exist with no newlines `\n` (use `printf`), which contains passphrase to unlock datasets in truenas

## Steps

### TrueNAS Core Setup

- Make sure disks are connected and TrueNAS can see them
- Install TrueNAS Core
- Make IP static
- Change hostname to `eggs`
- Validate/modify secrets in [secrets.yml](vars/secrets.yml) for TrueNAS
  - Run `ansible-vault edit ./vars/secrets.yml` to modify secrets
- Run `ansible-playbook eggs-playbook.yml`

### Remaining Setup

Remaining setup involves setting up cron jobs, periodic snapshots, replication snapshots, shares, settings, etc

#### With config file

If you have the truenas config file then remaining setup is easy

- Import TrueNAS config file via `System > General > Upload Config`
  - This will import the pool and restore any settings, jobs, etc you had

#### Without config file

- Import or create zpool via the UI
- (Optional) Setup `Periodic Snapshots Tasks` every day, with 1 day retention policy
- (Optional) Setup `Replication Tasks` same time as snapshot event time, with 7 days retention policy
  - Replicate to local backup pool if you have it set up
- Setup scrub task every month
- Setup NFS shares
<!-- - TODO: cron restic jobs, possibly healthcheck cron -->

### TrueNAS Automatic Unlock

If you have setup Raspberry PI with above instructions, you can use it to unlock all passphrase locked datasets.

- Generate ssh key pair on truenas box
- Copy truenas ssh public key to PI host (for password-less auth)
- Create a task in `Init/Shutdown Scripts` under `Tasks`
- Fill below ⬇️

| Name    | Value                                     |
| ------- | ----------------------------------------- |
| Command | /bin/sh /scripts/unlock_main_bootstrap.sh |
| When    | Post-Init                                 |
| Timeout | 120                                       |
