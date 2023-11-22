run_cmd
=========
This role ....

Requirements
------------
no requirements

Role Variables
--------------

| Variable | Required | Default     | Choices | Comments                                               |
|----------|----------|-------------|---------|--------------------------------------------------------|
| local    | no       | false       |         | run commands local, if true. on remote host, if false. |
| cmd      | no       | not defined |         | run single command                                     |
| cmds     | no       | not defined |         | run multiple commands (pass as a list of strings)      |
| log      | no       | true        |         | log output of the command                              |
cmd and cmds can be used both. the role will run all of them. 

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
    
        - role: <ROLE>
          vars:
              a: "a"
          tags: [<ROLE>]
          when: ('<ROLE>' in ansible_run_tags) or ('all_roles' in ansible_run_tags) or ( (ansible_run_tags|default([])) | length == 0 )
