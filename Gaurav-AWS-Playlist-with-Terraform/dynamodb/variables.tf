variable "region" {
  type = string
  description = "AWS region"
  default = "ap-south-1"
}

variable "table_name" {
  type = string
  default = "my-global-table"
}


# Capacity: 1 RCU = 1 strongly consistent read/s for items <= 4KB; 1WCU = 1 write/s for items <=1KB
# Scale these from your avg item size and target read/write per second
variable "read_capacity_units" {
  type = number
  default = 5
}

variable "write_capacity_units" {
  type = number
  default = 5
}