variable "region" {
  type = string
  default = "ap-south-1"
  description = "AWS region"
}

variable "instance_type" {
  type = string
  description = "AWS EC2 instance type"
  default = "t3.micro"
}