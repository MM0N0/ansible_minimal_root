app_ctrl
=========
With this role you can change the application state via commands. the role will wait until the stop/start was successful.

This role should only be used for small playbooks to trigger stop or start of an application.
It is not meant to be used in declarative master playbooks.

**make sure you use the syntax from the example playbook**

**don't** set vars like this:

        - role: app_ctrl
          vars:
            user: tomcat_usr
            cmd: "sudo systemctl stop tomcat.service"
            process_regex: "/[^ ]+/java/current//bin/java -Djava.util.logging.config.file=/[^ ]+/tomcat/current/conf/logging.properties -Djava.util.logging.manager=.*"
            wait_until: no_pid

vars are set globally, so the last declaration in the playbook is valid. In this case no commands will be executed, because cmds is set to [] in the last declaration.

**If you set vars like this, it will work as expected:**

        - role: app_ctrl
          user: tomcat_usr
          cmd: "sudo systemctl stop tomcat.service"
          process_regex: "/[^ ]+/java/current//bin/java -Djava.util.logging.config.file=/[^ ]+/tomcat/current/conf/logging.properties -Djava.util.logging.manager=.*"
          wait_until: no_pid



Requirements
------------
no requirements

Role Variables
--------------

| Variable      | Required | Default | Choices     | Comments                                                                              |
|---------------|----------|---------|-------------|---------------------------------------------------------------------------------------|
| user          | yes      |         |             | user to switch to for running the command                                             |
| cmd           | yes      |         |             | command to run                                                                        |
| process_regex | yes      |         |             | regex matching the process <br/><br/>example:<br/>"/[^ ]+/java/current//bin/java ..." |
| wait_until    | yes      |         | pid, no_pid | whether to check pid periodically until pid was found or until no pid was found       |
| process_user  | no       | .+      |             | user running the application (makes detecting the pid more stable)                    |
| log           | no       | false   |             | whether to log the output of the given command or not                                 |

Example Playbook
----------------

    - name: site
      gather_facts: no
      hosts: test_host
      become: yes
      become_method: sudo
      roles:

        - role: app_ctrl
          user: tomcat_usr
          cmd: "sudo systemctl stop tomcat.service"
          process_regex: "/[^ ]+/java/current//bin/java -Djava.util.logging.config.file=/[^ ]+/tomcat/current/conf/logging.properties -Djava.util.logging.manager=.*"
          wait_until: no_pid
    
          tags: [app_ctrl]
          when: ('app_ctrl' in ansible_run_tags) or ('all_roles' in ansible_run_tags)
    
        - role: app_ctrl
          user: tomcat_usr
          cmd: "sudo systemctl start tomcat.service"
          process_regex: "/[^ ]+/java/current//bin/java -Djava.util.logging.config.file=/[^ ]+/tomcat/current/conf/logging.properties -Djava.util.logging.manager=.*"
          wait_until: pid
          process_user: tomcat_usr
          log: true
    
          tags: [app_ctrl]
          when: ('app_ctrl' in ansible_run_tags) or ('all_roles' in ansible_run_tags)