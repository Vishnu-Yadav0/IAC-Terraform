variable "ami" {
  default = "ami-04a81a99f5ec58529"
}

variable "instance_type" {
  default = "t2.micro"

}

variable "iam_instance_profile" {
  default = "SessionManagerRole"
}

variable "subnet_id" {
  default = "subnet-0f51d390945911610"
}


