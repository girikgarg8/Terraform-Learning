variable "region" {
  type = string
  description = "AWS region"
  default = "ap-south-1"
}

variable "domain" {
  type = string
  description = "Domain name for hosted zone"
  default = "girikgarg.xyz"
}

variable "instance_type" {
  type = string
  description = "EC2 instance type for web server"
  default = "t3.micro"
}