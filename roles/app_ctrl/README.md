app_ctrl
=========
This role ....

Requirements
------------
no requirements

Role Variables
--------------

| Variable       | Required | Default | Choices | Comments                |
|----------------|----------|---------|---------|-------------------------|
| a              | yes      |         |         | a                       |
| b              | yes      |         |         | b                       |

Example Playbook
----------------

    - name: site
      gather_facts: no
      hosts: test_host
      become: yes
      become_method: sudo
      roles:
        - name: minimal_root_setup
          vars:
            devops_user: "{{ ansible_user }}"
    
        - role: app_ctrl
          a: "a"

          tags: [app_ctrl]
          when: ('app_ctrl' in ansible_run_tags) or ('all_roles' in ansible_run_tags) or ( (ansible_run_tags|default([])) | length == 0 )
