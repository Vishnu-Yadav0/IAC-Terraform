#tomcat
resource "aws_instance" "tomcat_try" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = "ubuntu"
  vpc_security_group_ids = ["sg-0e1fd9d99d0163865"]
  subnet_id              = "subnet-0f51d390945911610"
  iam_instance_profile   = var.iam_instance_profile
  #user_data              = file("/Users/ck/repos/iac-terraform/iac/web.sh")
  user_data = <<-EOF
  #!/bin/bash
  sudo hostnamectl set-hostname "tomcat.cloudbinary.io"
  echo "`hostname -I | awk '{ print $1}'` `hostname`" >> /etc/hosts
  sudo apt-get update
  sudo apt-get install vim curl elinks unzip wget tree git -y
  sudo apt-get install openjdk-17-jdk -y
  sudo cp -pvr /etc/environment "/etc/environment_$(date +%F_%R)"
  echo "JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/" >> /etc/environment
  source /etc/environment
  cd /opt/
  sudo wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.91/bin/apache-tomcat-9.0.91.tar.gz
  tar xvzf apache-tomcat-9.0.91.tar.gz
  mv apache-tomcat-9.0.91 tomcat
  sudo cp -pvr /opt/tomcat/conf/tomcat-users.xml "/opt/tomcat/conf/tomcat-users.xml_$(date +%F_%R)"
  sed -i '$d' /opt/tomcat/conf/tomcat-users.xml

  echo '<role rolename="manager-gui"/>'  >> /opt/tomcat/conf/tomcat-users.xml
  echo '<role rolename="manager-script"/>' >> /opt/tomcat/conf/tomcat-users.xml
  echo '<role rolename="manager-jmx"/>'    >> /opt/tomcat/conf/tomcat-users.xml
  echo '<role rolename="manager-status"/>' >> /opt/tomcat/conf/tomcat-users.xml
  
  echo '<role rolename="admin-gui"/>'     >> /opt/tomcat/conf/tomcat-users.xml
  echo '<role rolename="admin-script"/>' >> /opt/tomcat/conf/tomcat-users.xml

  echo '<user username="admin" password="linux@123" roles="manager-gui,manager-script,manager-jmx,manager-status,admin-gui,admin-script"/>' >> /opt/tomcat/conf/tomcat-users.xml
  
  echo "</tomcat-users>" >> /opt/tomcat/conf/tomcat-users.xml

  sudo cp -pvr /opt/tomcat/webapps/host-manager/META-INF/context.xml "/opt/tomcat/webapps/host-manager/META-INF/context.xml_$(date +%F_%R)"

  echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > /opt/tomcat/webapps/host-manager/META-INF/context.xml
  echo "<Context antiResourceLocking=\"false\" privileged=\"true\" >" >> /opt/tomcat/webapps/host-manager/META-INF/context.xml

  echo "</Context>  " >> /opt/tomcat/webapps/host-manager/META-INF/context.xml

  sudo cp -pvr /opt/tomcat/webapps/host-manager/META-INF/context.xml "/opt/tomcat/webapps/host-manager/META-INF/context.xml_$(date +%F_%R)"
  
  echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > /opt/tomcat/webapps/host-manager/META-INF/context.xml
  echo "<Context antiResourceLocking=\"false\" privileged=\"true\" >" >> /opt/tomcat/webapps/host-manager/META-INF/context.xml

  echo "</Context>  " >> /opt/tomcat/webapps/host-manager/META-INF/context.xml

  
  sudo cp -pvr /opt/tomcat/webapps/manager/META-INF/context.xml "/opt/tomcat/webapps/manager/META-INF/context.xml_$(date +%F_%R)"
  
  echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > /opt/tomcat/webapps/manager/META-INF/context.xml
  echo "<Context antiResourceLocking=\"false\" privileged=\"true\" >" >> /opt/tomcat/webapps/manager/META-INF/context.xml

  echo "</Context>  " >> /opt/tomcat/webapps/manager/META-INF/context.xml



  cd /opt/tomcat/bin/

  ./startup.sh

  EOF

  tags = {
    Name        = "tomcat_try"
    Environment = "Tomcat_try"
    ProjectName = "Cloud Binary"
    ProjectID   = "2024"
    CreatedBy   = "IaC Terraform"
  }
}





