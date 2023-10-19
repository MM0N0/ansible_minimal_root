minimal_root_setup
=========
This role adds a devops_group and creates the base_dir.

It is the base for all other roles in this collection, 
the applications are installed in the base_dir and 
the permissions needed are added to the devops_group.

Requirements
------------
no requirements

Role Variables
--------------
| Variable     | Required | Default | Choices | Comments                                                                                                                         |
|--------------|----------|---------|---------|----------------------------------------------------------------------------------------------------------------------------------|
| devops_user  | yes      |         |         | a user to be added to the devops_group (most likely ansible_user)                                                                |
| devops_group | yes      |         |         | a group used to provide the devops team with all necessary permissions for applications managed by the roles of this collection  |
| base_dir     | yes      |         |         | the base_dir, where all other roles in this collection will install its applications                                             |


Example Playbook
----------------

    - name: site
      gather_facts: no
      hosts: some_host
      become: yes
      become_method: sudo
      roles:
        - name: minimal_root_setup
          vars:
            devops_user: "{{ ansible_user }}"
            devops_group: "devops"
            base_dir:     "/applications"
