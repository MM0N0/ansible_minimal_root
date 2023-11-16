# Usage in an ansible project

## 1. create/add to the following `requirements.yml` file:
```yml
---
collections:
  - name: common.minimal_root
    source: <PATH_OF_THIS_REPO>
    version: <BRANCH/TAG/COMMIT-HASH>
    type: git
```

## 2. install this collection as a requirement in another ansible project
run:

```bash
ansible-galaxy collection install -r requirements.yml
```

or:

```bash
ansible-galaxy collection install -r requirements.yml --force
```
(to get latest changes, without version change)

## 3. use the roles in a playbook
```yml
- name: Install/Configure ElasticSearch
  hosts: foo
  roles:
    - role: common.minimal_root.elasticsearch
      vars: 
        foo: bar
#[...]
```