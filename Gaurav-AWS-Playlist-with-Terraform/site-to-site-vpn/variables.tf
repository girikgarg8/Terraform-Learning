variable "on_premises_region" {
  description = "AWS region for on-premises simulation"
  type        = string
  default     = "ap-south-1"
}

variable "aws_cloud_region" {
  description = "AWS region for cloud VPC"
  type        = string
  default     = "ap-south-2"
}

variable "key_name" {
  description = "EC2 Key Pair name for SSH access"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "on_premises_cidr" {
  description = "CIDR block for on-premises VPC"
  type        = string
  default     = "172.31.0.0/16"
}

variable "aws_cloud_cidr" {
  description = "CIDR block for AWS cloud VPC"
  type        = string
  default     = "10.0.0.0/16"
}