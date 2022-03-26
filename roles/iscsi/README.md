# iSCSI

Install `open-iscsi` client, discover targets on target machine,
login to it and mounts it

## Requirements

- iSCSI `iscsi_target_name` on `iscsi_host` should be discoverable

## Role Variables

- `iscsi_host` host where iSCSI target lives
- `iscsi_target_name` iSCSI target name
- `iscsi_config_directory` where to mount `iscsi_target_name` after it logins

## Example Playbook

```yml
- hosts: servers
  roles:
    - { role: iscsi }
```

## License

BSD

## Author Information

Ricky Dua - rd@rickydua.com
