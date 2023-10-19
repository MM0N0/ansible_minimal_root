apache2
=========
This role sets up an apache2 http server.

Requirements
------------
It requires a systemd based system. A service file is created at "/etc/systemd/system/" and the service is started.

Note: ONLY WORKS FOR UBUNTU, DUE TO THE USE OF APT

Role Variables
--------------
The following variables are used in this role:

| Variable               | Required | Default | Choices | Comments                                                                     |
|------------------------|----------|---------|---------|------------------------------------------------------------------------------|
| devops_group           | yes      |         |         | group gets sudoers permissions to switch to apache2_user                     |
| apache2_user           | yes      |         |         | user to own all apache2 related files (apache2 is still running as www-data) |
| apache2_group          | yes      |         |         | group to own all apache2 related files                                       |
| apache2_root_templates | no       |         |         | place critical files as root (certificates and keys)                         |
| apache2_templates      | no       |         |         | place all config and vhost files                                             |
| apache2_enable         | no       |         |         | enable config and vhost files                                                |

Example Playbook
----------------

    - name: site
      gather_facts: no
      hosts: apache2
      become: yes
      become_method: sudo
      vars:
          base_dir:     "/applications"
          devops_group: "devops"
      roles:
        - name: minimal_root_setup
          vars:
            devops_user: "{{ ansible_user }}"
    
        - role: apache2
          vars:
              apache2_user:   apache2
              apache2_group:  apache2

              test_project_apache2_root_templates:
                - { src: "{{ playbook_dir }}/templates/apache2/test-server.ag.pem", mode: "755", dest: "/etc/pki/tls/test-server.ag.pem" }
              apache2_templates: 
                - { src: "{{ playbook_dir }}/templates/apache2/conf/apache2.conf.j2", mode: "774", dest: "/etc/apache2/apache2.conf" }
            
              # these are parameters used in the template files:

              apache2_domain: "test_stuff.test-server.ag"
              apache2_max_keep_alive_requests: 123
