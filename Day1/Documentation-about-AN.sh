#!/bin/bash
# =====================================================
# Script: Ansible Documentation
# Description: Setup and configure Ansible infrastructure
# =====================================================

# =======================================
# INTRODUCTION TO ANSIBLE
# =======================================
# What is Ansible?
# -----------------
# Ansible is a popular automation tool for:
# - Configuration Management
# - Application Deployment
# - Orchestration

# Why Ansible?
# ------------
# - No Agent Required: Works without installing agents.
# - Flexible Connections:
#   - Cloud: Uses APIs
#   - Linux: Uses SSH
#   - Windows: Uses WINRM

# NOTE:
# -----
# Ansible is NOT a server. It executes tasks by running Python scripts.

# =======================================
# SETTING UP ANSIBLE INFRASTRUCTURE
# =======================================
# 1. Launch an EC2 instance for the Ansible control server.
# 2. Install Ansible using the official documentation.
# 3. Launch three additional EC2 instances as test nodes.
# 4. Connect these instances to the control server via SSH.

# =======================================
# CONFIGURING BACKEND CONNECTION
# =======================================
# 1. SSH into the control server:
#    ssh -i your_key.pem ec2-user@<control-server-ip>

# 2. Create a working directory:
mkdir -p ~/vprofile
cd ~/vprofile

# 3. Create an inventory file named 'inventory':
cat <<EOL > inventory
all:
  hosts:
    web01:
      ansible_host: 172.31.10.117
      ansible_user: ec2-user
      ansible_ssh_private_key_file: clientkey.pem
EOL

# Save the private key in the directory and set permissions:
chmod 400 clientkey.pem

# 4. Test the connection:
ansible web01 -m ping -i inventory

# =======================================
# CONFIGURING HOST KEY PERMISSIONS
# =======================================
# 1. Switch to root and edit Ansible configuration:
sudo su
nano /etc/ansible/ansible.cfg

# 2. Set host_key_checking to False:
echo "host_key_checking = False" >> /etc/ansible/ansible.cfg

# 3. Switch back to the regular user and verify:
exit
chmod 400 clientkey.pem

# =======================================
# EXPANDING INVENTORY: ADDING MULTIPLE HOSTS
# =======================================
# Update the inventory file to include more hosts and group them:
cat <<EOL > inventory_v2
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
EOL

# Test connectivity for all servers:
ansible all -m ping -i inventory_v2

# Test connectivity for specific groups:
ansible webservers -m ping -i inventory_v2
ansible dbservers -m ping -i inventory_v2

# =======================================
# NOTES
# =======================================
# - Always keep sensitive keys secure

