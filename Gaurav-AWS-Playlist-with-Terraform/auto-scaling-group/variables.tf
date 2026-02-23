variable "access_key" {
  type = string
  description = "Access key for terraform user"
}

variable "secret_key" {
  type = string
  description = "Secret key for terraform user"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name for SSH"
}

variable "clb_name" {
  type        = string
  description = "Name of existing Classic Load Balancer to attach"
}

variable "clb_security_group_id" {
  type        = string
  description = "Security group ID of the CLB (for instance SG: allow 80 from CLB)"
}