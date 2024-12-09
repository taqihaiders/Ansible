#!/bin/bash
# =====================================================
# Script: Ansible Documentation
# Description: Examples of Python, JSON, YAML, Ad-hoc Commands, Playbook, and Inventory Setup
# =====================================================

# =======================================
# PYTHON DICTIONARY EXAMPLE
# =======================================
cat <<EOP > dictionary_example.py
# Python Dictionary Example
dict = {
    "Devops": ["AWS", "Jenkins", "Python", "Ansible"],
    "development": ["Java", "python", "ruby"],
    "ansible_facts": {
        "python": "/usr/bin/python"
    }
}
EOP

# =======================================
# JSON EXAMPLE
# =======================================
cat <<EOJ > example.json
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
EOJ

# =======================================
# YAML EXAMPLE
# =======================================
cat <<EOY > example.yaml
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
EOY

# =======================================
# AD-HOC COMMANDS EXAMPLES
# =======================================
cat <<EOC > ad_hoc_commands.sh
#!/bin/bash
# Ad-hoc Commands in Ansible

# Install a package on a server
ansible web01 -m ansible.builtin.yum -a "name=httpd state=present" -i inventory --become

# Upload a file to the web server
ansible webservers -m ansible.builtin.copy -a "src=index.html dest=/var/www/html/index.html" -i inventory --become
EOC

# =======================================
# ANSIBLE PLAYBOOK: WEB AND DB SERVER CONFIGURATION
# =======================================
cat <<EOPB > web-db.yaml
# Webserver Configuration
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

# Database Server Configuration
- name: DBserver setup
  hosts: dbservers
  become: yes
  tasks:
    - name: Install mariadb-server
      ansible.builtin.yum:
        name: mariadb-server
        state: present
EOPB

# =======================================
# RUNNING ANSIBLE PLAYBOOK
# =======================================
cat <<EOR > run_playbook.sh
#!/bin/bash
# Run the Ansible Playbook for Web and DB Server Setup
ansible-playbook -i inventory web-db.yaml
EOR

# =======================================
# INVENTORY FILE EXAMPLE
# =======================================
cat <<EOI > inventory
all:
  hosts:
    web01:
      ansible_host: 172.31.10.117
      ansible_user: ec2-user
      ansible_ssh_private_key_file: clientkey.pem
    web02:
      ansible_host: 172.31.7.158
      ansible_user: ec2-user
      ansible_ssh_private_key_file: clientkey.pem
    db01:
      ansible_host: 172.31.1.130
      ansible_user: ec2-user
      ansible_ssh_private_key_file: clientkey.pem

  children:
    webservers:
      hosts:
        web01:
        web02:
    dbservers:
      hosts:
        db01:
EOI

echo "All files created successfully





# =====================================================
# Script: Ansible Documentation
# Description: Generates examples for Python, JSON, YAML, Ad-hoc Commands,
#              Playbook, and Inventory Setup.
# =====================================================

# =======================================
# HOW TO USE THIS SCRIPT
# =======================================
# 1. Save this script as ansible_documentation.sh.
# 2. Make it executable:
#    chmod +x ansible_documentation.sh
# 3. Run the script:
#    ./ansible_documentation.sh
# 4. The script will generate the following files:
#    - dictionary_example.py
#    - example.json
#    - example.yaml
#    - ad_hoc_commands.sh
#    - web-db.yaml
#    - run_playbook.sh
#    - inventory




