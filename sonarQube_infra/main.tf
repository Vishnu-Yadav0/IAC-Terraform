#SonarQube - Static Code Analysis
resource "aws_instance" "SonarQube" {
  ami                  = var.ami
  instance_type        = var.sonarQube_instanceType
  key_name             = "ubuntu"
  vpc_security_group_ids = ["sg-0e1fd9d99d0163865"]
  subnet_id            = "subnet-0f51d390945911610"
  iam_instance_profile = var.iam_instance_profile
  user_data            = <<-EOF
  #!/bin/bash
  sudo hostnamectl set-hostname "sonarQube.student.io"
  echo " `hostname - I | awk '{print $1}'` `hostname` " >> /etc/hosts
  sudo apt-get update
  sudo apt-get install git wget unzip zip curl tree -y
  sudo apt-get install docker.io -y
  sudo usermod -aG docker ubuntu
  sudo chmod 777 /var/run/docker.sock
  sudo systemctl enable docker
  sudo systemctl restart docker
  sudo docker pull sonarqube
  sudo docker images
  docker volume create sonarqube-conf
  docker volume create sonarqube-logs
  docker volume create sonarqube_data
  docker volume create sonarqube-extensions
  docker volume inspect sonarqube-conf
  docker volume inspect sonarqube-logs
  docker volume inspect sonarqube_data
  docker volume inspect sonarqube-extensions
  mkdir /sonarqube
  ln -s /var/lib/docker/volumes/sonarqube-conf/_data /sonarqube/conf
  ln -s /var/lib/docker/volumes/sonarqube-data/_data /sonarqube/data
  ln -s /var/lib/docker/volumes/sonarqube-logs/_data /sonarqube/logs
  ln -s /var/lib/docker/volumes/sonarqube-extensions/_data /sonarqube/extensions
  docker run -d --name c3opssonarqube -p 9000:9000 -p 9092:9092 -v sonarqube-conf:/sonarqube/conf -v sonarqube-data:/sonarqube/data -v sonarqube-logs:/sonarqube/logs -v sonarqube-extensions:/sonarqube/extensions sonarqube

  EOF

  tags = {
    Name        = "SonarQube"
    Environment = "Dev"
    ProjectName = "Cloud Binary"
    ProjectID   = "2024"
    CreatedBy   = "IaC Terraform"
  }

}