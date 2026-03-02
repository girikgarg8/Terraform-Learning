variable "region" {
  type = string
  description = "AWS region"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "EC2 Key Pair name"
}