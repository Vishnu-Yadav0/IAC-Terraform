terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}


#Variables
variable "ami" {
  default = "ami-04a81a99f5ec58529"
}

variable "instance_type" {
  default = "t2.micro"

}

variable "iam_instance_profile" {
  default = "SessionManagerRole"
}

variable "sonarQube_instanceType" {
  default = "t2.medium"
}

variable "eu_central_1_keypair" {
  default = "Frankfurt_KeyPair"
}

variable "eu_central_1_subnet_id" {
  default = "subnet-046d584d29da7d233"
}
  
variable "eu_central_1_security_group"{
  default = ["sg-008e431c32a7c33a0"]
}

resource "aws_instance" "docker-compose" {
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = var.eu_central_1_keypair
  vpc_security_group_ids = var.eu_central_1_security_group
  subnet_id            = var.eu_central_1_subnet_id
  iam_instance_profile = var.iam_instance_profile
  #user_data              = file("web.sh")
  user_data = <<-EOF
# Installing and Configuring docker

#!/bin/bash

# Setup New Hostname
sudo hostnamectl set-hostname "dcoker.compose.io"

# Configure New Hostname as part of /etc/hosts file 
sudo echo "`hostname -I | awk '{ print $1}'` `hostname`" >> /etc/hosts

# Update the Repository
sudo apt-get update

# Download, Install & Configure 
sudo apt-get install git wget unzip curl tree -y
sudo apt-get install docker.io -y 
sudo apt-get install docker-compose -y 
sudo usermod -aG docker ubuntu
sudo chmod 777 /var/run/docker.sock
sudo systemctl enable docker
sudo curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
sudo systemctl restart docker


  EOF

  tags = {
    Name      = "docker-compose"
    CreatedBy = "IaC-Terraform"
    Env       = "container"
  }
}
