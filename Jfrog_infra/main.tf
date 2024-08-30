resource "aws_instance" "Jfrog1" {
  ami                    = var.ami
  key_name               = "ubuntu"
  vpc_security_group_ids = ["sg-0e1fd9d99d0163865"]
  subnet_id              = "subnet-0f51d390945911610"
  instance_type          = var.instance_type
  iam_instance_profile   = var.iam_instance_profile
  user_data              = <<-EOF
    #!/bin/bash
    sudo hostnamectl set-hostname "jfrog.cloudbinary.io"
    echo "`hostname -I | awk '{ print $1}'` `hostname`" >> /etc/hosts
    sudo apt-get update
    sudo apt-get install vim curl elinks unzip wget tree git -y
    sudo apt-get install openjdk-17-jdk -y
    sudo cp -pvr /etc/environment "/etc/environment_$(date +%F_%R)"
    echo "JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/" >> /etc/environment
    source /etc/environment
    
    cd /opt/

    sudo wget https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/7.71.3/jfrog-artifactory-oss-7.71.3-linux.tar.gz

    tar xvzf jfrog-artifactory-oss-7.71.3-linux.tar.gz

    sudo rm -rf jfrog-artifactory-oss-7.71.3-linux.tar.gz 

    sudo mv artifactory-oss-7.71.3 jfrog

    sudo cp -pvr /etc/environment "/etc/environment_$(date +%F_%R)"

    echo "JFROG_HOME=/opt/jfrog" >> /etc/environment
    source /etc/environment

    cd /opt/jfrog/app/bin/

    sudo ./artifactory.sh status
    sudo ./artifactory.sh start


    EOF

  tags = {
    Name        = "JFrog1"
    Environment = "Dev"
    ProjectName = "Cloud Binary"
    ProjectID   = "2024"
    CreatedBy   = "IaC Terraform"
  }
}
