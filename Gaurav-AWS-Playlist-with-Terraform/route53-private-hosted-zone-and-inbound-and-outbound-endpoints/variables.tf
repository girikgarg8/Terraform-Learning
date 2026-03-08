variable "region" {
    type = string
    description = "AWS region"
    default = "ap-south-1"
}

variable "private_zone_name" {
    type = string
    description = "Private hosted zone domain name"
    default = "example.internal"
}

variable "test_vpc_cidr" {
    type = string
    description = "CIDR for test-vpc"
    default = "10.0.0.0/16"
}