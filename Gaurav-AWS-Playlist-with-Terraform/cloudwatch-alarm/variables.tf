variable "region" {
  type = string
  description = "AWS region"
  default = "ap-south-1"
}

variable "instance_type" {
  type = string
  description = "EC2 instance type"
  default = "t3.micro"
}

variable "sns_topic_name" {
  type = string
  description = "Name of existing SNS topic for alarm notifications"
  default = "mysampletopic"
}