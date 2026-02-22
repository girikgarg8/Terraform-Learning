variable "access_key" {
    type = string
    description = "Access key for Terraform user"
}

variable "secret_key" {
    type = string
    description = "Secret key for Terraform user"
}

variable "instance_type" {
    type = string
    description = "EC2 Instance type"
}

variable "key_name" {
    type = string
    description = "SSH Key name"
}