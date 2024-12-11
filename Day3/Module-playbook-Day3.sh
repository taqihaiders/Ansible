#!/bin/bash

# Title: Automating MySQL Database Setup with Ansible
# Author: [Your Name]
# Date: [Date]
# Description: 
# This script demonstrates how to use Ansible for automating the installation and configuration of a MySQL database,
# creating a new database, and adding a user with specific privileges. It includes explanations for every step
# to help understand Ansible concepts like modules and playbooks.

echo "Initializing Ansible MySQL Database Setup Automation..."

##############################################
# Explanation of Key Concepts
##############################################

# What is Ansible?
# - Ansible is an open-source IT automation tool that helps manage configurations, deploy applications, 
#   and perform task automation across servers.

# What is an Ansible Module?
# - A module in Ansible is a reusable, standalone script that performs specific tasks, like installing packages
#   or configuring services. Examples used here include:
#   - `yum`: Installs packages on Red Hat-based systems.
#   - `mysql_db`: Manages MySQL databases.
#   - `mysql_user`: Manages MySQL users and their privileges.

# What is an Ansible Playbook?
# - A playbook is a YAML file containing instructions for Ansible to execute tasks. 
#   It defines hosts, tasks, and configurations to automate.

##############################################
# Step 1: Installing Required Tools
##############################################
echo "Step 1: Installing necessary dependencies..."
sudo yum install -y ansible python3 python3-PyMySQL.noarch
# - Ansible: Required to execute automation tasks.
# - Python3: Ensures compatibility with MySQL modules.
# - PyMySQL: A Python library for connecting to MySQL databases.

##############################################
# Step 2: Creating Ansible Inventory
##############################################
echo "Step 2: Creating an Ansible inventory file..."
cat <<EOL > inventory
[dbservers]
db01 ansible_host=<your_db_server_ip> ansible_user=<your_ssh_user>
EOL
# The inventory file defines the hosts Ansible will manage.
# Replace `<your_db_server_ip>` with the IP of your database server.
# Replace `<your_ssh_user>` with the SSH user to access the server.

##############################################
# Step 3: Writing the Ansible Playbook
##############################################
echo "Step 3: Writing the Ansible playbook..."
cat <<'EOL' > db.yaml
---
- name: MySQL Database Setup
  hosts: dbservers
  become: yes
  tasks:
    # Task 1: Install MariaDB Server
    - name: Install MariaDB server
      ansible.builtin.yum:
        name: mariadb-server
        state: present
      # The `yum` module installs packages on Red Hat-based distributions.

    # Task 2: Start and Enable MariaDB Service
    - name: Start and enable MariaDB service
      ansible.builtin.service:
        name: mariadb
        state: started
        enabled: yes
      # The `service` module starts and enables services.

    # Task 3: Create a Database Named 'accounts'
    - name: Create a database named 'accounts'
      mysql_db:
        name: accounts
        state: present
        login_unix_socket: /var/lib/mysql/mysql.sock
      # The `mysql_db` module manages MySQL databases.

    # Task 4: Add a User Named 'vprofile'
    - name: Add a database user named 'vprofile'
      mysql_user:
        name: vprofile
        password: "51214"
        priv: "*.*:ALL"
        state: present
        login_unix_socket: /var/lib/mysql/mysql.sock
      # The `mysql_user` module manages MySQL users and their privileges.
EOL

##############################################
# Step 4: Running the Ansible Playbook
##############################################
echo "Step 4: Running the Ansible playbook..."
ansible-playbook -i inventory db.yaml
# The `ansible-playbook` command runs the playbook against the hosts defined in the inventory file.

##############################################
# Notes and Troubleshooting
##############################################
# Common Error: Access Denied for User 'root'@'localhost'
# - If you encounter this error, ensure the `login_unix_socket` path is specified correctly. 
# - The `login_unix_socket` value is typically `/var/lib/mysql/mysql.sock` for MariaDB installations.

# Learning Points:
# 1. Ansible Playbooks allow easy, repeatable server configurations.
# 2. Modules like `mysql_db` and `mysql_user` simplify database management tasks.
# 3. Refer to Ansible documentation to ensure correct syntax and usage.

echo "MySQL Database Setup Automation Completed!"

