java
=========
This role sets up a java jdk

Role Variables
--------------
| Variable               | Required | Default | Choices | Comments                                                                                                                                                                                                                                      |
|------------------------|----------|---------|---------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| java_base_dir          | yes      |         |         | base dir of java - it should be writeable by the devops_group and be a subdirectory of the base_dir from the role "minimal_root_setup". <br/>(unpacked folder will stay here and the symlink current will always point to the latest version) |
| java_user              | yes      |         |         | user to own all java related files                                                                                                                                                                                                            |
| java_group             | yes      |         |         | group to own all java related files                                                                                                                                                                                                           |
| java_dirname           | yes      |         |         | name of the directory inside the downloaded archive                                                                                                                                                                                           |
| java_download_url      | yes      |         |         | download url of the jdk (linux x64 tar.gz                                                                                                                                                                                                     |
| java_download_checksum | yes      |         |         | checksum of the jdk                                                                                                                                                                                                                           |
| java_download_username | no       |         |         | if defined is used for basic auth from java_download_url                                                                                                                                                                                      |
| java_download_password | no       |         |         | if defined is used for basic auth from java_download_url                                                                                                                                                                                      |

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
    
        - role: java
          vars:
            java_base_dir:  "{{ base_dir }}/java"
            java_user:      "java_user"
            java_group:     "java_group"
    
            java_dirname:           "OpenJDK11U-jdk_x64_linux_hotspot_11.0.19_7"
            java_download_filename: "{{ java_dirname }}.tar.gz"
            java_download_url:      "https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.19%2B7/{{ java_download_filename }}"
            java_download_checksum: "sha256:5f19fb28aea3e28fcc402b73ce72f62b602992d48769502effe81c52ca39a581"

            # java_download_url: "https://artifactory_link.war"
            # java_download_checksum: "sha256:796321ff4c2d2a9c44adeb546054d5bad6dg31166a27336c9f190013d40bd8f78"

            # java_download_username: "{{ basic_username }}"
            # java_download_password: "{{ basic_password }}"
          tags: [java]
          when: ('java' in ansible_run_tags) or ('all_roles' in ansible_run_tags) or ( (ansible_run_tags|default([])) | length == 0 )
