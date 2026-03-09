variable "aurora_engine_version" {
  description = "Aurora MySQL version"
  type = string
  default = "8.0.mysql_aurora.3.05.2"
}

variable "aurora_instance_class" {
  type = string
  default = "db.r6g.large"
}

variable "cluster_identifier_primary" {
  type = string
  default = "aurora-mysql-primary"
}

variable "cluster_identifier_replica" {
  type = string
  default = "aurora-mysql-replica"
}

variable "master_username" {
  type = string
  default = "admin"
}

variable "master_password" {
  type = string
  sensitive = true
  default = "password"
}

variable "replica_vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "replica_private_subnet_cidrs" {
  type = list(string)
  default = [ "10.0.1.0/24", "10.0.2.0/24"]
}

