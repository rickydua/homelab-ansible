# NFS

Installs `nfs-common` and mounts provided nfs share.

## Requirements

- NFS share should be visible and should have read/write permissions

## Role Variables

All default variables [here](./defaults/main.yml) can be overridden.

- `nfs_share` name of nfs share
- `nfs_mountpoint` where to mount nfs share
- `nfs_host` (Required) where to find nfs share

## Example Playbook

```yml
- hosts: servers
  roles:
    - { role: nfs }
```

## License

BSD

## Author Information

Ricky Dua - rd@rickydua.com
