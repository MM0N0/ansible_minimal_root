postgresql
=========
This role sets up a PostgreSQL database.
Note: this role also creates the user postgres

Requirements
------------
It requires a systemd based system. A service file is created at "/etc/systemd/system/" and the service is started.
Note: ONLY WORKS FOR UBUNTU

Role Variables
--------------
| Variable                       | Required | Default | Choices | Comments                                             |
|--------------------------------|----------|---------|---------|------------------------------------------------------|
| devops_group                   | yes      |         |         | group gets sudoers permissions to switch to postgres |
| pg_group                       | yes      |         |         | group to own all postgresql related files            |
| pg_database_superuser_user     | yes      |         |         | superuser username                                   |
| pg_database_superuser_password | yes      |         |         | superuser password                                   |
| pg_database_user               | yes      |         |         | non superuser username                               |
| pg_database_password           | yes      |         |         | non superuser password                               |
| pg_templates                   | yes      |         |         | place all config files                               | 
| pg_schemas                     | yes      |         |         | list of schemas to be created on the db              |

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


        - role: postgresql
          vars:
            pg_group: "postgres"
    
            pg_database_user:      "app_db_user"
            pg_database_password:  "app_db_pass"
            pg_database_superuser_user:      "admin"
            pg_database_superuser_password:  "top-secret"
    
            pg_databases:
              - "test_db"
    
            pg_schemas:
              - { name: "1424124", database: "test_db", owner: "{{ pg_database_user }}" }
              - { name: "test",    database: "test_db",  owner: "{{ pg_database_user }}" }
    
            pg_templates:
              - { src: "{{ playbook_dir }}/templates/postgresql/pg_hba.conf.j2",      mode: "640", dest: "/etc/postgresql/14/main/pg_hba.conf" }
              - { src: "{{ playbook_dir }}/templates/postgresql/postgresql.conf.j2",  mode: "644", dest: "/etc/postgresql/14/main/postgresql.conf" }
    
            # these are parameters used in the template files:
    
            pg_hba_rule: "host    all             {{ pg_database_user }}              localhost            trust"
            pg_listen_addresses: "*"

          tags: [postgresql]
          when: ('postgresql' in ansible_run_tags) or ('all_roles' in ansible_run_tags)

