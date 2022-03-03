# Docker

Installs docker and docker-compose, then sets a state to `docker_compose_state`

## Role Variables

All default variables [here](./defaults/main.yml) can be overridden.

- `docker_compose_directory` where `docker-compose.yml` will be
- `docker_compose_state`
  - present => `docker-compose up -d`
  - absent => `docker-compose down`

### For `docker-compose.yml.j2` template file

- `nfs_mountpoint` where docker containers configs would live
- `influxdb_pass` needed for `influxdb` container
- `pihole_pass` for `pihole` container

## Example Playbook

```yml
- hosts: servers
  roles:
    - { role: docker }
```

## License

BSD

## Author Information

Ricky Dua - rd@rickydua.com
