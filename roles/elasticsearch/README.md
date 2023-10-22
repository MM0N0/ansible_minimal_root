elasticsearch
=========
This role sets up an elasticsearch server.

Requirements
------------
It requires a systemd based system. A service file is created at "/etc/systemd/system/" and the service is started.
curl has to be installed on the target system.

Role Variables
--------------
The following variables are used in this role:

| Variable                  | Required | Default | Choices | Comments                                                                                                                                                                                                                                               |
|---------------------------|----------|---------|---------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| devops_group              | yes      |         |         | group gets sudoers permissions to switch to apache2_user                                                                                                                                                                                               |
| es_user                   | yes      |         |         | user to own all elasticsearch related files                                                                                                                                                                                                            |
| es_group                  | yes      |         |         | group to own all elasticsearch related files                                                                                                                                                                                                           |
| es_download_url           | yes      |         |         | download url of elasticsearch artifact (linux x64 .tar.gz)                                                                                                                                                                                             |
| es_download_checksum      | yes      |         |         | checksum of the elasticsearch artifact                                                                                                                                                                                                                 |
| es_base_dir               | yes      |         |         | base dir of elasticsearch - it should be writeable by the devops_group and be a subdirectory of the base_dir from the role "minimal_root_setup". <br/>(unpacked folder will stay here and the symlink current will always point to the latest version) |
| es_templates              | no       |         |         | place all config files                                                                                                                                                                                                                                 |
| es_admin_username         | yes      |         |         | username of the admin user                                                                                                                                                                                                                             |
| es_admin_password         | yes      |         |         | password of the admin user                                                                                                                                                                                                                             |
| es_create_role_templates  | no       |         |         | add role configurations in this form:<br/><br/> { name: "role-name",  template: "{{ playbook_dir }}/templates/es/roles/role-name-role.json.j2" }                                                                                                       |
| es_create_user_templates  | no       |         |         | add user configurations in this form:<br/><br/> { user: "user_ro",  password: "top-secret", full_name: "Tomas Schmidt", email: "qwertqt@mail.de", "roles": "[\\"read-only\\"]" }                                                                       |

Example Playbook
----------------

    - name: site
      gather_facts: no
      hosts: elasticsearch
      become: yes
      become_method: sudo
      vars:
          base_dir:     "/applications"
          devops_group: "devops"
      roles:
        - name: minimal_root_setup
          vars:
            devops_user: "{{ ansible_user }}"
    
        - role: elasticsearch
          vars:
            es_user:  "elasticsearch"
            es_group: "elasticsearch"
            
            es_base_dir: "{{ base_dir }}/elasticsearch"
            
            es_dirname:            "elasticsearch-8.9.0"
            es_download_filename:  "{{ es_dirname }}-linux-x86_64.tar.gz"
            es_download_url:       "https://artifacts.elastic.co/downloads/elasticsearch/{{ es_download_filename }}"                
            es_download_checksum:  "sha512:https://artifacts.elastic.co/downloads/elasticsearch/{{ es_download_filename }}.sha512"

            es_templates:
                - { src: "{{ playbook_dir }}/templates/es/jvm.options.j2",                               mode: "755", dest: "config/jvm.options" }
                - { src: "{{ playbook_dir }}/templates/es/config/elasticsearch.yml.j2",                  mode: "755", dest: "config/elasticsearch.yml" }
                - { src: "{{ playbook_dir }}/templates/es/jvm.options.d/elasticsearch.jvm.options.j2",   mode: "755", dest: "jvm.options.d/elasticsearch.jvm.options" }
                        
            test_project_es_create_role_templates:
                - { name: "read-only",  template: "{{ playbook_dir }}/templates/es/roles/read-only-role.json.j2" }
                - { name: "read-write", template: "{{ playbook_dir }}/templates/es/roles/read-write-role.json.j2" }
            test_project_es_create_user_templates:
                - { user: "user_ro",  password: "top-secret", full_name: "Tomas Schmidt", email: "qwertqt@mail.de", "roles": "[\\"read-only\\"]" } 
                - { user: "user_rw",  password: "top-secret", full_name: "Tomas Schmidt", email: "qwertqt@mail.de", "roles": "[\\"read-write\\"]" }

            es_admin_username: "admin"
            es_admin_password: "admin"
            
            # these are parameters used in the template files:

            es_heap_xms: "4g"
            es_cluster_name:                  "es-cluster"
            es_cluster_initial_master_nodes:  "es-node-1"
            es_node_name:             "es-node-1"
            es_bootstrap_memory_lock: true
            es_discovery_seed_hosts:  ["127.0.0.1", "[::1]"]
            es_network_host:          "127.0.0.1"
    
          tags: [es]
          when: ('es' in ansible_run_tags) or ('all_roles' in ansible_run_tags) or ( (ansible_run_tags|default([])) | length == 0 )
