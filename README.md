![Ansible Role](https://img.shields.io/ansible/role/d/38958)

# ahuffman.sudoers

Controls the configuration of the default `/etc/sudoers` file and included files/directories.

---
***Please note, release 2.0.0+ is a major re-write of the role.  Please read the documentation to ensure you understand the changes prior to installation and use if coming from prior versions.***

---

## Table of Contents
<!-- TOC depthFrom:2 depthTo:6 withLinks:1 updateOnSave:0 orderedList:1 -->

1. [Table of Contents](#table-of-contents)
2. [Tips](#tips)
3. [Role Variables](#role-variables)
4. [sudoers_files Dictionary Fields](#sudoers_files-dictionary-fields)
	1. [sudoers_files.aliases Dictionary Fields](#sudoers_filesaliases-dictionary-fields)
		1. [cmnd_alias Dictionary Fields](#cmnd_alias-dictionary-fields)
		2. [host_alias Dictionary Fields](#host_alias-dictionary-fields)
		3. [runas_alias Dictionary Fields](#runas_alias-dictionary-fields)
		4. [user_alias Dictionary Fields](#user_alias-dictionary-fields)
	2. [user_specifications Dictionary Fields](#user_specifications-dictionary-fields)
		1. [Standard user_specifications](#standard-user_specifications)
		2. [Default Override user_specifications](#default-override-user_specifications)
5. [Automatically Generating the Sudoers Files Data from an Existing Configuration](#automatically-generating-the-sudoers-files-data-from-an-existing-configuration)
6. [Example Playbooks](#example-playbooks)
	1. [RHEL7.6 Default Sudoers Configuration](#rhel76-default-sudoers-configuration)
		1. [Results: /etc/sudoers](#results-etcsudoers)
	2. [Sudoers Configuration (multiple files)](#sudoers-configuration-multiple-files)
		1. [Results: /etc/sudoers](#results-etcsudoers)
		2. [Results: /etc/sudoers.d/pingers](#results-etcsudoersdpingers)
		3. [Results: /etc/sudoers.d/root](#results-etcsudoersdroot)
	3. [Migrating a Running Sudoers Configuration to Another Host](#migrating-a-running-sudoers-configuration-to-another-host)
11. [License](#license)
12. [Author Information](#author-information)

<!-- /TOC -->

## Tips
|*Tip:* Here's a few excellent resources on sudoers configuration:|
|---|
|[Start here](https://help.ubuntu.com/community/Sudoers) - Provides a great run-down on basic sudoers file configurations and terminology|
|[Sudoers Manual](https://www.sudo.ws/man/1.8.15/sudoers.man.html) - If you want to know all the details, this is for you.|

## Role Variables
The defaults defined for this role are based on a default RHEL7.6 `/etc/sudoers` configuration.  Please check the defaults in [`defaults/main.yml`](defaults/main.yml) prior to running for OS compatibility.

| Variable Name | Description | Default Value | Variable Type |
| --- | --- | :---: | :---: |
| sudoers_rewrite_default_sudoers_file | Use role default or user defined `sudoers_files` definition, replacing your distribution supplied `/etc/sudoers` file.  Useful when attempting to deploy new configuration files to the `include_directories` and you do not wish to modify the `/etc/sudoers` file. | True | boolean |
| sudoers_remove_unauthorized_included_files | ***Very Dangerous!*** Each existing sudoer file found in the `include_directories` dictionary which have not been defined in `sudoers_files` will be removed. This allows for enforcing a desired state. | False | boolean |
| sudoers_backup | Whether or not to create a backup of the current state of the existing `/etc/sudoers` file as well as any files defined in `sudoers_files`.  The files get backed up to the Ansible control node (Server you are executing Ansible from) and avoids accidentally leaving files behind in your `include_directories` that may be evaluated by the sudoers configuration(s).| True | boolean |
| sudoers_backup_path | Path relative to where you are executing your playbook to backup the remote copies of defined `sudoers_files` to. | "sudoers_backups" | string |
| sudoers_backup_become | Whether or not to use sudo when creating local sudoers backup directory and sudoers file backups | True | boolean |
| sudoers_visudo_path | Fully-qualified path to the `visudo` binary required for validation of sudoers configuration changes. Added for Operating System compatibility. | "/usr/sbin/visudo" | string |
| sudoers_files | Definition of all your sudoers configurations | see [defaults/main.yml](defaults/main.yml)| list of dictionaries |

## sudoers_files Dictionary Fields
| Variable Name | Description | Variable Type |
| --- | --- | :---: |
| path | Where to deploy the configuration file to on the filesystem. | string |
| aliases | Optional definition of `cmnd_alias`, `host_alias`, `runas_alias`, or `user_alias` items. | dictionary |
| defaults | This allows you to define the defaults of your sudoers configuration. Default overrides can be perfomed via the [`user_specifications`](#default-override-user_specifications) key.| list |
| include_files | Optional specific files that you would like your configuration to include.  This is a list of fully-qualified paths to include via the `#include` option of a sudoers configuration. | list |
| include_directories | Optional specific directories that you would like your configurations to include.  This is a list of fully-qualified paths to directories to include via the `#includedir` option of a sudoers configuration. | list |
| user_specifications | List of user specifications and default overrides to apply to a sudoers file configuration. | list |

### sudoers_files.aliases Dictionary Fields
| Variable Name | Description | Variable Type |
| --- | --- | :---: |
| cmnd_alias | List of command alias definitions. | list of dictionaries |
| host_alias | List of host alias definitions | list of dictionaries |
| runas_alias | List of runas alias definitions | list of dictionaries |
| user_alias | List of user alias definitions | list of dictionaries |

#### cmnd_alias Dictionary Fields
| Variable Name | Description | Variable Type |
| --- | --- | :---: |
| name | Name of the command alias. | string |
| commands | List of commands to apply to the alias | list |

#### host_alias Dictionary Fields
| Variable Name | Description | Variable Type |
| --- | --- | :---: |
| name | Name of the host alias. | string |
| hosts | List of hosts to apply to the alias | list |

#### runas_alias Dictionary Fields
| Variable Name | Description | Variable Type |
| --- | --- | :---: |
| name | Name of the runas alias | string |
| users | List of users to apply to the alias | list |

#### user_alias Dictionary Fields
| Variable Name | Description | Variable Type |
| --- | --- | :---: |
| name | Name of the user_alias | string |
| users | List of users to apply to the alias | list |

### user_specifications Dictionary Fields
This dictionary can be used to assign either user specifications or default overrides.

#### Standard user_specifications
| Variable Name | Description | Variable Type |
| --- | --- | :---: |
| users | List of users to apply the specification to. You can use a `user_alias` name as well as user names. | list |
| hosts | List of hosts to apply the specification to.  You can use a defined `host_alias` name as well as host names. | list |
| operators | List of operators to apply the specification to. You can use a defined `runas_alias` name as well as user names. | list |
| selinux_role | Optional selinux role to apply to the specification | list |
| selinux_type | Optional selinux type to apply to the specification | list |
| solaris_privs | Optional Solaris privset to apply to the specification | list |
| solaris_limitprivs | Optional Solaris privset to apply to the specification | list |
| tags | Optional list of tags to apply to the specification. | list |
| commands | List of commands to apply the specification to.  You can use a defined `cmnd_alias` name as well as commands. | list |

#### Default Override user_specifications
| Variable Name | Description | Variable Type |
| --- | --- | :---: |
| defaults | List of defaults to override from the main configuration | list |
| type | Type of default to override, this affects the operator in the configuration ( host -> `@`, user -> `:`, command -> `!`, and runas -> `>`).  The type field can be one of the following values: `command`, `host`, `runas`, or `user`. | string |
| commands | Use when `type: "command"`.  List of `cmnd_alias` names as well as commands to override specific default values.| list |
| hosts | Use when `type: "host"`.  List of `host_alias` names as well as individual host names to override specific default values. | list |
| operators | Use when `type: "runas"`. List of `runas_alias` names as well as individual user names to override specific default values. | list |
| users | Use when `type: "user"`.  List of `user_alias` names as well as individual user names to override specific default values. | list |

## Automatically Generating the Sudoers Files Data from an Existing Configuration
Does this all sound way too complicated to configure from the documentation?  Please check out and try [ahuffman.scan_sudoers](https://galaxy.ansible.com/ahuffman/scan_sudoers) to find a role that can auto-generate the proper data structure for you.  With the [ahuffman.scan_sudoers](https://galaxy.ansible.com/ahuffman/scan_sudoers) role, you can take a running configuration in one play, and lay it down on another with the [ahuffman.sudoers](https://galaxy.ansible.com/ahuffman/sudoers) role (version 2.0.0+).  You could also opt to take the collected data and push it into a source of truth such as a CMDB or repository via automation.  The collected data that is generated by [ahuffman.scan_sudoers](https://galaxy.ansible.com/ahuffman/scan_sudoers) and can be consumed by [ahuffman.sudoers](https://galaxy.ansible.com/ahuffman/sudoers) would be `{{ ansible_facts['sudoers'].sudoers_files }}`.

This should help alleviate some of the complication of manually defining the sudoers configurations as code, and get you up and running much quicker.

See the [Playbook Example](#migrating-a-running-sudoers-configuration-to-another-host) below.


## Example Playbooks
### RHEL7.6 Default Sudoers Configuration
```yaml
- name: "Apply a RHEL7.6 Default /etc/sudoers configuration"
  hosts: "all"
  roles:
    - role: "ahuffman.sudoers"
```
...or with modern syntax:
```yaml
- name: "Apply a RHEL7.6 Default /etc/sudoers configuration"
  hosts: "all"
  tasks:
    - name: "Configure /etc/sudoers"
      include_role:
        name: "ahuffman.sudoers"
```

#### Results: /etc/sudoers

The above two examples using the role defaults will produce a `/etc/sudoers` configuration file that looks like this:  
```
# Ansible managed

# Default specifications
Defaults    !visiblepw
Defaults    always_set_home
Defaults    match_group_by_gid
Defaults    always_query_group_plugin
Defaults    env_reset
Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin
Defaults    env_keep = "COLORS DISPLAY HOSTNAME HISTSIZE KDEDIR"
Defaults    env_keep += "LS_COLORS MAIL PS1 PS2 QTDIR"
Defaults    env_keep += "USERNAME LANG LC_ADDRESS LC_CTYPE LC_COLLATE"
Defaults    env_keep += "LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES LC_MONETARY LC_NAME"
Defaults    env_keep += "LC_NUMERIC LC_PAPER LC_TELEPHONE LC_TIME LC_ALL"
Defaults    env_keep += "LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"

# User specifications
root ALL=(ALL) ALL
%wheel ALL=(ALL) ALL

# Includes
## Include directories
#includedir /etc/sudoers.d
```

### Sudoers Configuration (multiple files)

```yaml
- name: "Apply a multi-file sudoers configuration"
  hosts: "all"
  tasks:
    - name: "Configure /etc/sudoers and included files"
      include_role:
        name: "ahuffman.sudoers"
      vars:
        sudoers_rewrite_default_sudoers_file: True
        sudoers_remove_unauthorized_included_files: True
        sudoers_backup: True
        sudoers_backup_path: "sudoers-backups"
        sudoers_files:
          - path: "/etc/sudoers"
            defaults:
              - "!visiblepw"
              - "always_set_home"
              - "match_group_by_gid"
              - "always_query_group_plugin" # maintains sudo pre-1.8.15 group behavior
              - "env_reset"
              - secure_path:
                  - "/sbin"
                  - "/bin"
                  - "/usr/sbin"
                  - "/usr/bin"
              - env_keep:
                  - "COLORS"
                  - "DISPLAY"
                  - "HOSTNAME"
                  - "HISTSIZE"
                  - "KDEDIR"
                  - "LS_COLORS"
                  - "MAIL"
                  - "PS1"
                  - "PS2"
                  - "QTDIR"
                  - "USERNAME"
                  - "LANG"
                  - "LC_ADDRESS"
                  - "LC_CTYPE"
                  - "LC_COLLATE"
                  - "LC_IDENTIFICATION"
                  - "LC_MEASUREMENT"
                  - "LC_MESSAGES"
                  - "LC_MONETARY"
                  - "LC_NAME"
                  - "LC_NUMERIC"
                  - "LC_PAPER"
                  - "LC_TELEPHONE"
                  - "LC_TIME"
                  - "LC_ALL"
                  - "LANGUAGE"
                  - "LINGUAS"
                  - "_XKB_CHARSET"
                  - "XAUTHORITY"
            user_specifications:
              - users:
                  - "root"
                hosts:
                  - "ALL"
                operators:
                  - "ALL"
                commands:
                  - "ALL"
              - users:
                  - "%wheel"
                hosts:
                  - "ALL"
                operators:
                  - "ALL"
                commands:
                  - "ALL"
            include_directories:
              - "/etc/sudoers.d"
            aliases:
              cmnd_alias:
                - name: "PING"
                  commands:
                    - "/bin/ping"
              user_alias:
                - name: "PINGERS"
                  users:
                    - "ahuffman"
          - path: "/etc/sudoers.d/pingers"
            user_specifications:
              - type: "user"
                defaults:
                  - "!requiretty"
                users:
                  - "PINGERS"
          - path: "/etc/sudoers.d/root"
            defaults:
              - "syslog=auth"
            user_specifications:
              - type: "runas"
                defaults:
                  - "!set_logname"
                operators:
                  - "root"
```

The example above will produce the following configuration files:
#### Results: /etc/sudoers

```
# Ansible managed

# Default specifications
Defaults    !visiblepw
Defaults    always_set_home
Defaults    match_group_by_gid
Defaults    always_query_group_plugin
Defaults    env_reset
Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin
Defaults    env_keep = "COLORS DISPLAY HOSTNAME HISTSIZE KDEDIR"
Defaults    env_keep += "LS_COLORS MAIL PS1 PS2 QTDIR"
Defaults    env_keep += "USERNAME LANG LC_ADDRESS LC_CTYPE LC_COLLATE"
Defaults    env_keep += "LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES LC_MONETARY LC_NAME"
Defaults    env_keep += "LC_NUMERIC LC_PAPER LC_TELEPHONE LC_TIME LC_ALL"
Defaults    env_keep += "LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"

# Alias specifications
## Command Aliases
Cmnd_Alias    PING = /bin/ping

## User Aliases
User_Alias    PINGERS = ahuffman

# User specifications
root ALL=(ALL) ALL
%wheel ALL=(ALL) ALL

# Includes
## Include directories
#includedir /etc/sudoers.d
```
#### Results: /etc/sudoers.d/pingers

```
# Ansible managed

# Default override specifications
Defaults:PINGERS !requiretty
```

#### Results: /etc/sudoers.d/root

```
# Ansible managed

# Default specifications
Defaults    syslog=auth


# Default override specifications
Defaults>root !set_logname
```

### Migrating a Running Sudoers Configuration to Another Host

```yaml
---
- name: "Collect Existing Sudoers Facts"
  hosts: "source-host"
  tasks:
    - name: "Collect Running Sudoers Configuration"
      include_role:
        name: "ahuffman.scan_sudoers"

    - name: "Set Collected Sudoers Facts"
      set_fact:
        sudoers_files: "{{ ansible_facts['sudoers'].sudoers_files }}"

    - name: "Display Collected Sudoers Configuration Facts"
      debug:
        var: "sudoers_files"
        verbosity: "1"

- name: "Deploy Running Configuration to Target"
  hosts: "destination-host"
  tasks:
    - include_role:
        name: "ahuffman.sudoers"
      vars:
        sudoers_remove_unauthorized_included_files: True
```
The above example provides a method of using Infrastructure-as-Code in Reverse to take a known configuration converted to structured data to drive future automation.  Alternatively to directly provisioning the collected configuration on a new host, you could push the data into a CMDB or repository for future use as a source of truth.

## License

[MIT](LICENSE)

## Author Information

[Andrew J. Huffman](https://github.com/ahuffman)  
[Tyler Cross](https://github.com/wtcross)  
