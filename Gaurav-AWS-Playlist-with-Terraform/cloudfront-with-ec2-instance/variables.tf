variable "access_key" {
  type = string
  description = "Access key for terraform user"
}

variable "secret_key" {
  type = string
  description = "Secret key for terraform user"
}

variable "region" {
  type = string
  description = "AWS region"
}

variable "instance_type" {
  type = string
  description = "EC2 instance type"
}