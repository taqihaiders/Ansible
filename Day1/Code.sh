#!/bin/bash
# =======================================
# Script: Create Inventory File
# =======================================

mkdir -p ~/vprofile
cd ~/vprofile

# Create inventory file with one host
cat <<EOL > inventory
all:
  hosts:
    web01:
      ansible_host: 172.31.10.117
      ansible_user: ec2-user
      ansible_ssh_private_key_file: clientkey.pem
EOL

# Set permissions for private key
chmod 400 clientkey.pem

echo "Inventory file created successfully!"

