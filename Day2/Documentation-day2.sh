#!/bin/bash
# =====================================================
# Script: YAML, JSON, and Ansible Learning
# Description: A structured overview of YAML, JSON, and Ansible concepts.
# =====================================================

# =======================================
# PYTHON DICTIONARY
# =======================================
# Below is the Python dictionary we will convert into YAML and JSON formats.

dict = {
    "Devops": ["AWS", "Jenkins", "Python", "Ansible"],
    "development": ["Java", "python", "ruby"],
    "ansible_facts": {
      "python": "/usr/bin/python"
    }
}

# =======================================
# JSON FORMAT
# =======================================
# JSON structure converts the dictionary into columns with double quotes.
# Syntax is stricter, and brackets are used for organization.

{
    "Devops": [
        "AWS",
        "Jenkins",
        "Python",
        "Ansible"
    ],
    "development": [
        "Java",
        "python",
        "ruby"
    ],
    "ansible_facts": {
        "python": "/usr/bin/python"
    }
}

# =======================================
# YAML FORMAT
# =======================================
# YAML simplifies the data by removing brackets and quotes.
# It uses indentation for structure and dashes for lists.

Devops:
- AWS
- Jenkins
- Python
- Ansible

Development:
- Java
- python
- ruby

ansible_facts:
  python: /usr/bin/python
  version: 2.7

# =======================================
# AD-HOC COMMANDS IN ANSIBLE
# =======================================
# Ad-hoc commands are used for one-time tasks without playbooks.

# 1. Installing a package:
ansible web01 -m ansible.builtin.yum -a "name=httpd state=present" -i inventory --become

# 2. Uploading files:
ansible webservers -m ansible.builtin.copy -a "src=index.html dest=/var/www/html/index.html" -i inventory --become

# NOTE:
# Open the browser and navigate to the server's IP to verify if the file is deployed.

# =======================================
# ANSIBLE PLAYBOOK
# =======================================
# Playbooks are YAML files for automating tasks in a structured way.

# Webserver configuration:
- name: Webserver setup
  hosts: webservers
  become: yes
  tasks:
    - name: Install httpd
      ansible.builtin.yum:
        name: httpd
        state: present

    - name: Start service
      ansible.builtin.service:
        name: httpd
        state: started
        enabled: yes

# Database server configuration:
- name: DBserver setup
  hosts: dbservers
  become: yes
  tasks:
    - name: Install mariadb-server
      ansible.builtin.yum:
        name: mariadb-server
        state: present

# Running the playbook:
# Save the playbook as 'web-db.yaml' and run:
ansible-playbook -i inventory web-db.yaml

# =======================================
# ADDITIONAL NOTES
# =======================================
# - YAML is more readable and easier for configurations, while JSON is compact and widely used in APIs.
# - Use ad-hoc commands for quick tasks but prefer playbooks for scalability.
# - Always test configurations with `ansible -m ping` before applying changes.
# - Keep your inventory and playbooks organized

