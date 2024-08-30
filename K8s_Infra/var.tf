variable "ami" {
  default = "ami-0ad21ae1d0696ad58"
}

variable "instance_type" {
  default = "t2.micro"

}

variable "iam_instance_profile" {
  default = "SessionManagerRole"
}

variable "medium" {
  default = "t2.medium"
}

variable "key_name" {
  default = "mumbai-keypair"
}

variable "eu_central_1_subnet_id" {
  default = "subnet-03a6076e3cd649e39"
}

variable "eu_central_1_security_group" {
  default = ["sg-0141d75274d803c93"]
}

variable "region" {
  default ="eu-central-1"
}