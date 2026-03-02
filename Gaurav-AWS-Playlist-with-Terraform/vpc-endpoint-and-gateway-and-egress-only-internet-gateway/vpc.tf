# VPC with IPv6 support
resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
 assign_generated_ipv6_cidr_block = true
 enable_dns_hostnames = true
 enable_dns_support = true

 tags = {
    Name = "VPC-Endpoints-Demo"
 }
}

# Public subnet (for bastion)

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-subnet"
  }
}

# Private subnet for Gateway endpoint demo
resource "aws_subnet" "private_gateway" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Private-Gateway-Subnet"
  }
}

# Private subnet for Interface endpoint demo

resource "aws_subnet" "private_interface" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "Private-Interface-Subnet"
  }
}

# IPv6-enabled subnet for EIGW demo (dual-stack)
resource "aws_subnet" "ipv6_only" {
  vpc_id                          = aws_vpc.main.id
  cidr_block                      = "10.0.4.0/24"
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, 4)
  assign_ipv6_address_on_creation = true
  availability_zone               = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "IPv6-Enabled-Subnet"
  }
}