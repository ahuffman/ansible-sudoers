# sudoers
> An Ansible role for comprehensive management of a sudoers configuration.

[![Build Status](https://travis-ci.org/wtcross/ansible-sudoers.svg?branch=master)](https://travis-ci.org/wtcross/ansible-sudoers)

This role makes it possible to completely define your sudoers configuration with Ansible. All of the following are configurable:
- defaults
- aliases
- specifications

*Tip:* Here's a [great document about sudoers configuration](https://help.ubuntu.com/community/Sudoers)

## Design
The top level `/etc/sudoers` file is kept as light as possible. It includes all defaults and aliases. All sudoer specifications will each be placed in their own file within the `/etc/sudoers.d/` directory. When it comes to sudoer specifications this role favors explicit over implicit configuration. That means you must set each of these properties for a specification:
- `name`: the name of the specification (file name in `/etc/sudoers.d/`)
- `users`: user list or user alias
- `hosts`: host list or host alias
- `operators`: operator list or runas alias
- `commands`: command list or command alias

The following properties are optional:
- `tags`: list of tags (ex: NOPASSWD)

## Example Playbook
```yaml
# a super contrived example
- hosts: all

  vars:
    sudoer_aliases:
      user:
        - name: ADMINS
          users:
            - %admin
      runas:
        - name: ROOT
          users:
            - '#0'
      host:
        - name: SERVERS
          hosts:
            - 192.168.0.1
            - 192.168.0.2
      command:
        - name: ADMIN_CMNDS
          commands:
            - /usr/sbin/passwd
            - /usr/sbin/useradd
            - /usr/sbin/userdel
            - /usr/sbin/usermod
            - /usr/sbin/visudo
    sudoer_specs:
      - name: administrators
        users: ADMIN
        hosts: SERVERS
        operators: ROOT
        tags:
          - NOPASSWD
        commands: ADMIN_CMNDS

  roles:
    - role: sudoers
```

## Requirements
The host operating system must be a member of one of the following OS families:

- Debian
- RedHat
- SUSE

## Dependencies
None

## Variable Schemas
```yaml
# host alias
name: string
hosts: string|[hostnames]

# user alias
name: string
users: string|[username|%group]

# runas alias
name: string
users: string|[username|%group|#uid]

# cmnd alias
name: string
commands: string|[string]

# sudoer specification
name: string
users: string|[string]
hosts: string|[string]
operators: string|[string]
tags: string|[string]
```

## Role Variables
- `sudoer_aliases`: a dictionary that specifies which aliases to configure
  - `sudoer_aliases.host`: a list of host alias descriptions
  - `sudoer_aliases.user`: a list of host alias descriptions
  - `sudoer_aliases.runas`: a list of host alias descriptions
  - `sudoer_aliases.command`: a list of host alias descriptions
- `sudoer_specs`: a list of sudoer specifications
- `sudoer_defaults`: a list of default settings
  - can be any of the following types
    - `string`
    - `string: string`
    - `string: [string]`

## License
[MIT](LICENSE)
