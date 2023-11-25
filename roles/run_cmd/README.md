run_cmd
=========
This role ....

Requirements
------------
no requirements

Role Variables
--------------

| Variable      | Required | Default                                                             | Choices | Comments                                                             |
|---------------|----------|---------------------------------------------------------------------|---------|----------------------------------------------------------------------|
| local         | no       | false                                                               |         | run commands local, if true. on remote host, if false.               |
| user          | no       | local user, if run locally. ansible_user, if you run on remote host |         | run commands as this user (make sure you have permission to do this) |
| cmd           | no       | not defined                                                         |         | run single command                                                   |
| cmds          | no       | not defined                                                         |         | run multiple commands (pass as a list of strings)                    |
| log           | no       | true                                                                |         | log output of the command                                            |
| changed_when  | no       | true                                                                |         | mark running the cmd(s) as a change                                  |
cmd and cmds can be used both. the role will run all of them.

Example Playbook 
----------------

    - name: site
      gather_facts: no
      hosts: test_host
      become: yes
      become_method: sudo
      roles:


        - role: run_cmd
          cmds:
            - "echo 'HELLO WORLD'"
            - "pwd"
    
          tags: [run_cmd]
          when: ('run_cmd' in ansible_run_tags) or ('all_roles' in ansible_run_tags)
    
    
        - role: run_cmd
          user: user
          cmd: whoami
    
          tags: [run_cmd]
          when: ('run_cmd' in ansible_run_tags) or ('all_roles' in ansible_run_tags)
    
    
        - role: run_cmd
          user: user
          cmd: whoami
          cmds:
            - "echo 'HELLO WORLD'"
            - "pwd"
          changed_when: false
    
          tags: [run_cmd]
          when: ('run_cmd' in ansible_run_tags) or ('all_roles' in ansible_run_tags)
    
    
        - role: run_cmd
          local: true
          cmd: "pwd"
          log: false
          changed_when: false
    
          tags: [run_cmd]
          when: ('run_cmd' in ansible_run_tags) or ('all_roles' in ansible_run_tags)
