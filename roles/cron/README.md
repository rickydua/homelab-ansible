# Cron

Installs cron jobs on root user.

Scripts are copied from `./files/scripts` over to remote machine's `scripts_directory`.

## Requirements

- Working `rickyd.duckdns.org` domain for `duck.sh` to work

## Role Variables

All default variables [here](./defaults/main.yml) can be overridden.

- `docker_compose_directory` is needed for [update_docker_containers.sh](./files/scripts/update_docker_containers.sh) to be able to locate directory where `docker-compose.yml` file is in

- `scripts_directory` is where all scripts would be installed on target machine

## Example Playbook

Using this role

```yml
- hosts: servers
  roles:
    - { role: cron }
```

## License

BSD

## Author Information

Ricky Dua - `rd@rickydua.com`
