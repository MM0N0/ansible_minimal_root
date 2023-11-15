# Ansible Collection - minimal_root
[![test master](https://github.com/MM0N0/ansible_minimal_root/actions/workflows/test_main.yml/badge.svg)](https://github.com/MM0N0/ansible_minimal_root/actions/workflows/test_main.yml)

This is a [collection](https://docs.ansible.com/ansible/devel/collections_guide/index.html)
of [Ansible](https://www.ansible.com) [roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html)
for setting up various systems.

It is focused on only using root, if absolutely necessary,
to make it usable on restrictive systems. 

**Note**: this is work in progress

## Collection Contents:

### Roles
- generic roles:
  - [minimal_root_setup](roles/minimal_root_setup/README.md)
  - [files](roles/files/README.md)
- application roles:
  - [apache2](roles/apache2/README.md)
  - [elasticsearch](roles/elasticsearch/README.md)
  - [postgresql](roles/postgresql/README.md)
  - [tomcat](roles/tomcat/README.md)

## Requirements
- docker and docker-compose
- bash

note: if you are using windows, you will have to use wsl

## Installation
test setup by running:

```bash
.test/test_role.sh files
```

## Documentation

### Usage in an ansible project

#### 1. create/add to the following `requirements.yml` file:
```yml
---
collections:
  - name: common.minimal_root
    source: <PATH_OF_THIS_REPO>
    version: <BRANCH/TAG/COMMIT-HASH>
    type: git
```

#### 2. install this collection as a requirement
run:

```bash
ansible-galaxy collection install -r requirements.yml
```

or:

```bash
ansible-galaxy collection install -r requirements.yml --force
```
(to get latest changes, without version change)

#### 3. use the roles in a playbook
```yml
- name: Install/Configure ElasticSearch
  hosts: ...
  roles:
    - role: common.minimal_root.elasticsearch
      vars:
        ...
```

# TODOs

- update README
  - install collection inside dev_docker [*]

  - add good usage example [here](#3-use-the-roles-in-a-playbook)
  - [write a role](docs/how_to/write_a_role.md)
- improve tests
- update role tomcat
  - maybe download tar from artifactory
- update role postgresql
  - way to create multiple users needed
  - way to create dbs needed

## Contribute
...

## License
...

## Author Information
...
