variable "region" {
  type = string
  description = "AWS region"
}

variable "access_key" {
  type = string
  description = "Access key for terraform user"
}

variable "secret_key" {
  type = string
  description = "Secret key for terraform user"
}

variable "vpc_cidr" {
  type = string
  description = "VPC CIDR range"
}

variable "public_subnet_cidr" {
  type = string
  description = "Public subnet CIDR"
}

variable "private1_subnet_cidr" {
  type = string
  description = "Private subnet 1 CIDR"
}

variable "private2_subnet_cidr" {
  type = string
  description = "Private subnet 2 CIDR"
}

variable "nat_instance_type" {
  type = string
  description = "NAT EC2 Instance Type"
}

variable "key_name" {
  type = string
  description = "SSH key name"
}

variable "instance_type" {
  type = string
  description = "EC2 instance type"
}