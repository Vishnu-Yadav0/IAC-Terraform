resource "aws_instance" "ansible_cm" {
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = var.eu_central_1_keypair
  vpc_security_group_ids = var.eu_central_1_security_group
  subnet_id            = var.eu_central_1_subnet_id
  iam_instance_profile = var.iam_instance_profile
  #user_data              = file("web.sh")
  user_data = <<-EOF
# Installing and Configuring Ansible [Ansible Controller] 

#!/bin/bash

# Setup New Hostname
sudo hostnamectl set-hostname "ansible.controller.io"

# Configure New Hostname as part of /etc/hosts file 
sudo echo "`hostname -I | awk '{ print $1}'` `hostname`" >> /etc/hosts

# Update the Repository
sudo apt-get update

# Download, Install & Configure Ansible
sudo apt-get install git wget unzip curl tree -y
sudo apt install software-properties-common -y

sudo add-apt-repository --yes --update ppa:ansible/ansible

sudo apt install ansible -y 

# Backup the Environment File
sudo cp -pvr /etc/ansible/hosts "/etc/ansible/hosts_$(date +%F_%R)"

# Create Environment Variables
echo "[web]" > /etc/ansible/hosts


curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#add a iam_instance_profile (role) which contains ec2-describe policy
# to print ip address and instanceids
#aws ec2 describe-instances --query 'Reservations[].Instances[].[InstanceId,PrivateIpAddress]' --output text

#echo "`aws ec2 describe-instances --query 'Reservations[].Instances[].[PrivateIpAddress]' --output text`" >> /etc/ansible/hosts

#to add private ip address of ansible_node to the ansible hosts file
#echo "`aws ec2 describe-instances --instance-ids i-0f0f6b95a1298cc06 --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text`" >> /etc/ansible/hosts

# aws ec2 describe-instances --instance-ids i-0f0f6b95a1298cc06 --query 'Reservations[0].Instances[0].PublicIpAddress' --output text
# aws ec2 describe-instances --instance-ids i-0f0f6b95a1298cc06 --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text


#add user
sudo adduser automation

#set the password for the new user
echo 'automation:Redhat@123' | chpasswd

#add the new user to the sudo group
usermod -aG sudo automation

#Ensure the home directory permissions are correct
chown -R automation:automation /home/automation 

#Add a custom string to the /etc/sudoefs file using visudo
echo "%automation ALL=(ALL) NOPASSWD:ALL" | EDITOR='tee -a' visudo

#modify the SSH configuration to allow password authentication
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config


#Restart the SSh service to apply the changes
sudo service ssh restart

#switch to the new user and generate SSH key pair
su - automation -c "ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ' '"


#to print instance ids of a particular tag
#aws ec2 describe-instances \
#  --filters "Name=tag:env,Values=ansible-node" \
#  --query "Reservations[*].Instances[*].InstanceId" \
#  --output text

#printing publicIpAddress of instance which have a particular tag values
#echo "`aws ec2 describe-instances   --filters "Name=tag:env,Values=ansible-node"  \
# --query "Reservations[*].Instances[*].PrivateIpAddress"  \
# --output text`" > ansible_node_private_ip_address.txt


#printing publicIpAddress of instance which have a particular tag values
#echo "`aws ec2 describe-instances   --filters "Name=tag:env,Values=ansible-node"  \
# --query "Reservations[*].Instances[*].PublicIpAddress"  \
# --output text`" > ansible_node_public_ip_address.txt

# Replace '/path/to/authorized_keys' with the correct path on the remote server
#su - controller_user -c "sshpass -p 'Controller_pass' ssh-copy-id -i ~/.ssh/id_rsa.pub remote_user@remote_host"

#su - automation -c "sshpass -p 'Redhat@123' ssh-copy-id -i ~/.ssh/id_rsa.pub automation@3.120.40.60"

#it copies to the same path on remote machine as it exists on local machine
#su - automation -c "sshpass -p 'Redhat@123' ssh automation@3.120.40.60 'mkdir -p ~/.ssh && cat >> ~/.ssh/id_rsa.pub'" < ~/.ssh/id_rsa.pub

#sshpass -p 'Redhat@123' ssh automation@3.120.40.60 'mkdir -p ~/.ssh && cat >> ~/.ssh/id_rsa.pub' < ~/.ssh/id_rsa.pub

  EOF

  tags = {
    Name      = "ansible_cm"
    CreatedBy = "IaC-Terraform"
    Env       = "ansible_cm"
  }
}
