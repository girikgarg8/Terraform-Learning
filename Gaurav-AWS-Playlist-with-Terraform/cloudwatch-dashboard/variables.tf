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

variable "dashboard_name" {
  type = string
  description = "Dashboard name"
  default = "EC2-CPU-Network-Dashboard"
}

variable "dashboard_shared_iam_usernames" {
  type = list(string)
  description = "IAM usernames to allow viewing the dashboard"
  default = [ "alice" ]
}