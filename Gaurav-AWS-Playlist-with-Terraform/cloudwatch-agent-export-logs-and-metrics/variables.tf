variable "region" {
  type = string
  default = "ap-south-1"
  description = "AWS region"
}

variable "instance_type" {
  type = string
  default = "t3.micro"
  description = "EC2 instance type"
}

variable "log_group_name" {
  type = string
  default = "/aws/ec2/cloudwatch-agent-demo"
  description = "Cloudwatch log group for agent logs"
}

variable "metrics_namespace" {
  type = string
  default = "CWAgent"
}