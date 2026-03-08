variable "region" {
  type = string
  description = "AWS region"
  default = "ap-south-1"
}

variable "vpc_cidr" {
  type = string
  description = "VPC CIDR"
  default = "10.0.0.0/16"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR for private subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR for public subnets (e.g. for EC2 bastion)"
  default     = ["10.0.3.0/24"]
}

variable "db_instance_class" {
  type = string
  description = "MariaDB Instance class"
  default = "db.m5.large"
}

variable "db_allocated_storage_gb" {
  type        = number
  description = "Storage size for DB (GiB)"
  default     = 100
}

variable "master_username" {
  type = string
  description = "Master username for DB"
  default = "admin"
}

variable "master_password" {
  type = string
  description = "Master password for DB"
  default = "password"
  sensitive = true
}

variable "db_name" {
  type = string
  description = "Database name"
  default = "mariadb_demo"
}