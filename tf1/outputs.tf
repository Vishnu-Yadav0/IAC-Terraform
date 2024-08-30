output "public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "private_ip" {
  value = aws_instance.jenkins.private_ip
}

output "instance_type" {
  value = aws_instance.jenkins.instance_type
}

output "iam_instance_profile" {
  value = aws_instance.jenkins.iam_instance_profile
}

#SonarQube
output "sonarQube_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "sonarQube_private_ip" {
  value = aws_instance.SonarQube.private_ip
}

output "sonarQube_instance_type" {
  value = aws_instance.SonarQube.instance_type
}

output "sonarQube_iam_instance_profile" {
  value = aws_instance.SonarQube.iam_instance_profile
}

#tomcat
output "tomcat_public_ip" {
  value = aws_instance.tomcat.public_ip
}

output "tomcat_private_ip" {
  value = aws_instance.tomcat.private_ip
}

output "tomcat_instance_type" {
  value = aws_instance.tomcat.instance_type
}