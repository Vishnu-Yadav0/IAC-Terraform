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
