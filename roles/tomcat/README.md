tomcat
=========
This role sets up an apache tomcat server

Requirements
------------
It requires a systemd based system. A service file is created at "/etc/systemd/system/" and the service is started.

Role Variables
--------------
| Variable                 | Required | Default | Choices | Comments                                                                                                                                                                                                                                        |
|--------------------------|----------|---------|---------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| devops_group             | yes      |         |         | group gets sudoers permissions to switch to tomcat_user                                                                                                                                                                                         |
| tomcat_user              | yes      |         |         | user to own all tomcat related files                                                                                                                                                                                                            |
| tomcat_group             | yes      |         |         | group to own all tomcat related files                                                                                                                                                                                                           |
| tomcat_base_dir          | yes      |         |         | base dir of tomcat - it should be writeable by the devops_group and be a subdirectory of the base_dir from the role "minimal_root_setup". <br/>(unpacked folder will stay here and the symlink current will always point to the latest version) |
| tomcat_download_url      | yes      |         |         | download url of tomcat (linux x64 .tar.gz)                                                                                                                                                                                                      |
| tomcat_download_filename | yes      |         |         | filename of the downloaded archive                                                                                                                                                                                                              |
| tomcat_download_checksum | yes      |         |         | checksum of the downloaded archive                                                                                                                                                                                                              |
| tomcat_dirname           | yes      |         |         | name of the directory inside the downloaded archive                                                                                                                                                                                             |
| tomcat_webapps           | yes      |         |         | list of files to download from basic-auth protected  source, like the artifactory.                                                                                                                                                              |
| tomcat_templates         | yes      |         |         | place all config files                                                                                                                                                                                                                          |

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


        - role: tomcat
          vars:
            tomcat_user:      "tomcat"
            tomcat_group:     "tomcat"
            tomcat_base_dir:  "{{ base_dir }}/tomcat"

            tomcat_dirname:           "apache-tomcat-8.5.95"
            tomcat_download_filename: "{{ tomcat_dirname }}.tar.gz"
            tomcat_download_url:      "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.95/bin/{{ tomcat_download_filename }}"
            tomcat_download_checksum: "sha512:1c36d0de6ef0c1bab090bfb30908f8cf848510ab83d6140890e2e1db001e8a4d0d5982a53c92e4cc7a736de304b22f461706689c48160e24c299dae7a148a673"
            
            tomcat_webapps:
                - { filename: "app-0.0.1.war", url: "{{ artefactory_webapps_path }}/country/chat/0.0.1", 
                    checksum: "sha256:03eda78207f7d4c93d8086a815331a0b20987ff1c322b14956656066ac862982", 
                    mode: "0755", username: "{{ basic_username }}", password: "{{ basic_password }}" }

            tomcat_templates: 
              - { src: "{{ playbook_dir }}/templates/tomcat/conf/context.xml",      mode: "755", dest: "conf/context.xml" }
              - { src: "{{ playbook_dir }}/templates/tomcat/conf/server.xml",       mode: "755", dest: "conf/server.xml" }
              - { src: "{{ playbook_dir }}/templates/tomcat/conf/tomcat-users.xml", mode: "755", dest: "conf/tomcat-users.xml" }
              - { src: "{{ playbook_dir }}/templates/tomcat/conf/web.xml",          mode: "755", dest: "conf/web.xml" }
              - { src: "{{ playbook_dir }}/templates/tomcat/lib/log4j.properties",  mode: "755", dest: "lib/log4j.properties" }
              - { src: "{{ playbook_dir }}/templates/tomcat/lib/log4j2.xml",        mode: "755", dest: "lib/log4j2.xml" }
              - { src: "{{ playbook_dir }}/templates/tomcat/bin/catalina.sh",       mode: "755", dest: "bin/catalina.sh" }
              - { src: "{{ playbook_dir }}/templates/tomcat/bin/setenv.sh.j2",      mode: "755", dest: "bin/setenv.sh" }
                
            tags: [tomcat]
