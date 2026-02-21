variable "access_key" {
  type = string
  description = "Access key for Terraform user"
}

variable "secret_key" {
  type = string
  description = "Secret key for Terraform user"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "SSH key pair name in AWS"
}