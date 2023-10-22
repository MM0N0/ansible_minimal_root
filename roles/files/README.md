files
=========
This role sets up generic files and templates

Requirements
------------
no requirements

Role Variables
--------------

| Variable        | Required | Default | Choices | Comments                                                                                                                                                                                                                                                                                                                                                                                                   |
|-----------------|----------|---------|---------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| download_files  | yes      |         |         | list of files to download from basic-auth protected  source, like the artifactory. <br/>Example:<br/>- { filename: "app-0.0.1.war", url: "https://artifactory.anything.com/artifactory/some-release/de/tmp/webapps/any/app/0.0.1", checksum: "sha256:03eda78207f7d4c93d8086a815331a0b20987ff1c322b14956656066ac862982", mode: "0755", username: "{{ basic_username }}", password: "{{ basic_password }}" } |
| root_files      | yes      |         |         | place files as root                                                                                                                                                                                                                                                                                                                                                                                        |
| root_templates  | yes      |         |         | place templates as root                                                                                                                                                                                                                                                                                                                                                                                    |
| root_files      | yes      |         |         | place files                                                                                                                                                                                                                                                                                                                                                                                                |
| root_files      | yes      |         |         | place templates                                                                                                                                                                                                                                                                                                                                                                                            |

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
    
        - role: files
          vars:
              download_files:
                - { filename: "app-0.0.1.war", url: "{{ artefactory_webapps_path }}/country/chat/0.0.1", 
                    checksum: "sha256:03eda78207f7d4c93d8086a815331a0b20987ff1c322b14956656066ac862982", 
                    mode: "0755", username: "{{ basic_username }}", password: "{{ basic_password }}" }
              root_files:
                - { src: "{{ playbook_dir }}/templates/test_root_file", 
                    owner: "root", group: "root", mode: "755", 
                    dest: "/etc/test_root_file" }
              files:
                - { src: "{{ playbook_dir }}/templates/test_file",      
                    owner: "user", group: "user", mode: "755", 
                    dest: "{{ base_dir }}/aaa/test_file" }
              root_templates:
                - { src: "{{ playbook_dir }}/templates/template_test_root_file", 
                    owner: "root", group: "root", mode: "755", 
                    dest: "/etc/template_test_root_file" }
              templates:
                - { src: "{{ playbook_dir }}/templates/template_test_file",      
                    owner: "user", group: "user", mode: "755", 
                    dest: "{{ base_dir }}/aaa/template_test_file" }
          tags: [files]
          when: ('files' in ansible_run_tags) or ('all_roles' in ansible_run_tags) or ( (ansible_run_tags|default([])) | length == 0 )
