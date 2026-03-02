# VPC 1
resource "aws_vpc" "vpc1" {
  cidr_block = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "VPC1"
  }
}

resource "aws_subnet" "vpc1_public" {
  vpc_id = aws_vpc.vpc1.id
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0]


  tags = {
    Name = "VPC1-Public-Subnet"
  }
}

# VPC 2
resource "aws_vpc" "vpc2" {
  cidr_block = "10.2.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "VPC2"
  }
}

resource "aws_subnet" "vpc2_public" {
  vpc_id = aws_vpc.vpc2.id
  cidr_block = "10.2.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "VPC2-Public-Subnet"
  }
}