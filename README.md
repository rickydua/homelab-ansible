# Setting/Restoring Homelab from scratch

![GitHub Workflow Status (branch)](https://img.shields.io/github/workflow/status/rickydua/homelab-ansible/Build/master?style=for-the-badge)

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
  - chicken debian/ubuntu host aka docker host
- Raspberry PI (optional, if you don't want to type passphrase for dataset every time truenas restarts)
  - Luks container at `/secure.img` with `$LUKS_PASS`
  - Dir `/mnt/vault` with `chmod 777`
  - `/mnt/vault/truenas_passphrase` file should exist on `pi_host` with no newlines `\n` (use `printf`), which contains passphrase to unlock datasets in truenas

## Steps

### TrueNAS Core Setup

- Make sure disks are connected and TrueNAS can see them
- Install TrueNAS Core
- Validate/modify secrets in [secrets.yml](vars/secrets.yml) for TrueNAS
  - Run `ansible-vault edit ./vars/secrets.yml` to modify secrets
- Confirm values in `host_vars/eggs.yml`
- Run `ansible-playbook eggs.yml`

### Remaining Setup

Remaining setup involves setting up cron jobs, periodic snapshots, replication snapshots, shares, settings, etc

#### With config file

If you have the truenas config file then remaining setup is easy

- Import TrueNAS config file via `System > General > Upload Config`
  - This will import the pool and restore any settings, jobs, etc you had

#### Without config file

- Make IP static
- Change hostname to `eggs`
- Change timezone to `Pacific/Auckland`
- Confirm Network DNS, Default Route settings
- Import or create zpool via the UI
- Create NFS shares
- Create Zvol under `pool/eggs` named `dconfig` with sparse 20GiB
- Share `dconfig` Zvol via iSCSI target also named `dconfig`

#### Optional steps

- (Optional) Setup `Periodic Snapshots Tasks` every day, with 1 day retention policy
- (Optional) Setup `Replication Tasks` same time as snapshot event time, with 7 days retention policy
  - Replicate to local backup pool if you have it set up
- Setup scrub task every month
<!-- - TODO: cron restic jobs, possibly healthcheck cron -->

### TrueNAS Automatic Unlock

If you have setup Raspberry PI with above instructions, you can use it to unlock all passphrase locked datasets.

- Generate TrueNAS API Token
  - `Settings` -> `API Keys`
  - Modify `truenas_api_token` in `vars/secrets.yml`
- Confirm `/mnt/vault/truenas_passphrase` on pi is correct
- Generate ssh key pair on truenas box
- Copy truenas ssh public key to PI host (for password-less auth)
  - Confirm that we can ssh as `root` on `pi`
  - Run `ssh-copy-id -i ~/.ssh/id_rsa.pub root@pi`
- Run `ansible-playbook eggs.yml` just to be sure
- Create a task in `Init/Shutdown Scripts` under `Tasks`
- Fill below ⬇️

| Name    | Value                                     |
| ------- | ----------------------------------------- |
| Command | /bin/sh /scripts/unlock_main_bootstrap.sh |
| When    | Post-Init                                 |
| Timeout | 120                                       |

### Traffic & Chicken

- Traffic should be target for port forwarding (from the router) as its going to acquire
  letsencrypt certificates
- Confirm values in:
  - [host_vars/traffic.yml](host_vars/traffic.yml)
  - [vars/secrets.yml](vars/secrets.yml)
  - [host_vars/chicken.yml](host_vars/chicken.yml)
- Run `ansible-playbook site.yml`
