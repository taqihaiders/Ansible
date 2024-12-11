#!/bin/bash

# Ansible Configuration and Variable Setup for Day 4
# This script will walk through setting up Ansible, creating variables, and understanding other key concepts.

# Set the Ansible Configuration File
echo "Setting up the Ansible Configuration file"

# Create ansible.cfg in the appropriate directory
cat <<EOF > ansible.cfg
[defaults]
inventory = ./hosts
remote_user = root
private_key_file = /path/to/ssh/key
host_key_checking = False
EOF

echo "Ansible Configuration has been set up in 'ansible.cfg'"

# Define variables in an Ansible playbook (Example)
echo "Creating Ansible Playbook with variables"

cat <<EOF > setup_playbook.yml
---
- name: DBserver setup
  hosts: dbservers
  become: yes
  vars:
    dbname: electric
    dbuser: current
    dbpass: tesla
  tasks:
    - debug:
        msg: "The database name is {{ dbname }}"
    - debug:
        var: dbuser
    - name: Create database user
      mysql_user:
        name: "{{ dbuser }}"
        password: "{{ dbpass }}"
        state: present
        login_unix_socket: /var/lib/mysql/mysql.sock
      register: dbout
    - debug:
        var: dbout
EOF

echo "Playbook 'setup_playbook.yml' with variables has been created."

# Handling Conditional Execution (Provisioning for Different Systems)
echo "Setting up provisioning tasks for Ubuntu and CentOS servers"

cat <<EOF > provision_servers.yml
---
- name: Provisioning servers
  hosts: all
  become: yes
  tasks:
    - name: install ntp agent on CentOS
      yum:
        name: chrony
        state: present
      when: ansible_distribution == "CentOS"
    - name: Install ntp agent on Ubuntu
      apt:
        name: ntp
        state: present
        update_cache: yes
      when: ansible_distribution == "Ubuntu"
EOF

echo "Provisioning tasks have been added to 'provision_servers.yml'"

# Loop through tasks to install multiple packages
echo "Creating a playbook to install multiple packages using loops"

cat <<EOF > install_packages.yml
---
- name: Install packages on CentOS
  hosts: all
  become: yes
  tasks:
    - name: Install multiple packages
      yum:
        name: "{{ item }}"
        state: present
      when: ansible_distribution == "CentOS"
      loop:
        - chrony
        - wget
        - git
        - zip
        - unzip
EOF

echo "Package installation loop added in 'install_packages.yml'"

# Fact Gathering (Getting system facts)
echo "Gathering system facts using Ansible setup module"

ansible -m setup web01

echo "Facts have been gathered for 'web01'"

# Group-level variables for different servers
echo "Setting up Group Variables for specific server groups"

mkdir -p group_vars
cat <<EOF > group_vars/webservers.yml
---
dbhost: db01.example.com
dbport: 3306
EOF

echo "Group variables for webservers added in 'group_vars/webservers.yml'"

# Final Message
echo "Day 4 Ansible setup is complete with Configuration, Variables, Provisioning, and Loops."


