---
# Day 5 Script with Key Concepts Implemented

## File Template ##
# We are going to test file modules like copying data from one file to another on different servers.
# This task will ensure that the file copy operation is carried out correctly.

## Handlers ##
# Handlers are not executed until they are notified.

# Concept:
# In the previous task, we worked with the file module to copy files between two servers.
# We noticed that when we ran the `ansible-playbook` command, the modules always made changes during the "restart" step, even if no change had occurred.
# With handlers, tasks will only run when there is an actual change. If there is no change in the file, the handler will be ignored.

# Example:
# After modifying the CentOS configuration file (e.g., adding ### to the file), running the playbook will update only the CentOS server and leave the Ubuntu server unchanged.

## Testing with Handlers:
- name: Test handlers with file changes
  hosts: all
  become: yes
  tasks:
    - name: Modify the CentOS configuration file
      copy:
        src: /path/to/local/config_file
        dest: /path/to/remote/config_file
        content: "### Modified Config"
      notify:
        - Restart service # This handler will only trigger if the file is modified.

  handlers:
    - name: Restart service
      service:
        name: some_service
        state: restarted

## Roles ##
# Ansible roles help modularize playbooks, making them easier to manage and more reusable.

# Concept:
# When working with large playbooks, they can become difficult to manage due to multiple configurations. By using roles, we can simplify our playbook structure.
# Roles allow for better organization and reusability, especially at the organizational level.

# Steps:
# 1. We created a directory called `roles` and started storing different parts of the playbook there (tasks, handlers, variables, etc.).
# 2. Roles are organized into separate directories, such as `tasks`, `handlers`, `vars`, and more.

# Example:
- name: Provisioning servers
  hosts: all
  become: yes
  roles:
    - post-install

# Now we have structured files. For example, if we want to modify handlers, we can simply edit the `handlers` section within the role.

## Overwriting Variable Values in Roles ##
# This step shows how to overwrite variable values within a role.

# Steps:
# 1. Copy exercise files (14 to 15).
# 2. Change the NTP server in the `vars` file.
# 3. Move variables from the `vars` folder to `defaults`.
# 4. Modify the playbook to overwrite variables using the `vars` section.

- name: Provisioning servers
  hosts: all
  become: yes
  roles:
    - role: post-install
      vars:
        ntp0: 0.north-america.pool.ntp.org
        ntp1: 1.north-america.pool.ntp.org
        ntp2: 2.north-america.pool.ntp.org
        ntp3: 3.north-america.pool.ntp.org

## Adding a Role from Ansible Galaxy ##
# Suppose we want to install and add a random role from Ansible Galaxy to the playbook.

# Steps:
# 1. Install the role from Ansible Galaxy using `ansible-galaxy role install zhan9san.java`.
# 2. Add this role to the playbook.

- name: Provisioning servers
  hosts: all
  become: yes
  roles:
    - zhan9san.java
    - role: post-install
      vars:
        ntp0: 0.north-america.pool.ntp.org
        ntp1: 1.north-america.pool.ntp.org
        ntp2: 2.north-america.pool.ntp.org
        ntp3: 3.north-america.pool.ntp.org

## Ansible for AWS Integration ##
# Now we will work with AWS services using Ansible.

# Steps:
# 1. Create an AWS user with access keys.
# 2. SSH into the Ansible server and add the access key to `.bashrc`.
# 3. Source `.bashrc` to load the keys.

# Example:
- hosts: localhost
  gather_facts: False
  tasks:
    - name: Create a key pair
      ec2_key:
        name: sample
        region: ap-south-1
      register: keyout

    - name: Print key
      debug:
        var: keyout

# Save the key to a file only when there is a change:
- name: Save key
  copy:
    content: "{{ keyout.key.private_key }}"
    dest: ./sample.pem
  when: keyout.changed

## Launching EC2 Instance with Ansible ##
# Launching an EC2 instance using Ansible after configuring the AWS module.

# Steps:
# 1. Install the `amazon.aws` role via `ansible-galaxy`.
# 2. Use the `ec2_instance` module to launch an EC2 instance.

- ec2_instance:
    name: "public-compute-instance"
    key_name: "sample"
    vpc_subnet_id: subnet-5ca1ab1e
    instance_type: t2.micro
    security_group: default
    image_id: ami-123456
    region: ap-south-1
    tags:
      Environment: Testing

