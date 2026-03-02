# AWS Cloud VPC (ap-south-2)
resource "aws_vpc" "aws_cloud" {
  provider   = aws.aws_cloud
  cidr_block = var.aws_cloud_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "AWS-Cloud-VPC"
    Type = "AWS-Production"
  }
}

# Private subnet for AWS instance
resource "aws_subnet" "aws_cloud_private" {
  provider          = aws.aws_cloud
  vpc_id            = aws_vpc.aws_cloud.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.aws_cloud_azs.names[0]

  tags = {
    Name = "AWS-Cloud-Private-Subnet"
    Type = "Production-Workload"
  }
}

# Public subnet for bastion (optional - for troubleshooting)
resource "aws_subnet" "aws_cloud_public" {
  provider                = aws.aws_cloud
  vpc_id                  = aws_vpc.aws_cloud.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.aws_cloud_azs.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "AWS-Cloud-Public-Subnet"
    Type = "Management"
  }
}

# Internet Gateway for AWS Cloud VPC
resource "aws_internet_gateway" "aws_cloud_igw" {
  provider = aws.aws_cloud
  vpc_id   = aws_vpc.aws_cloud.id

  tags = {
    Name = "AWS-Cloud-IGW"
  }
}

# Route table for AWS Cloud public subnet
resource "aws_route_table" "aws_cloud_public" {
  provider = aws.aws_cloud
  vpc_id   = aws_vpc.aws_cloud.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_cloud_igw.id
  }

  tags = {
    Name = "AWS-Cloud-Public-RT"
  }
}

# Route table for AWS Cloud private subnet
resource "aws_route_table" "aws_cloud_private" {
  provider = aws.aws_cloud
  vpc_id   = aws_vpc.aws_cloud.id

  tags = {
    Name = "AWS-Cloud-Private-RT"
  }
}

# Route table associations
resource "aws_route_table_association" "aws_cloud_public" {
  provider       = aws.aws_cloud
  subnet_id      = aws_subnet.aws_cloud_public.id
  route_table_id = aws_route_table.aws_cloud_public.id
}

resource "aws_route_table_association" "aws_cloud_private" {
  provider       = aws.aws_cloud
  subnet_id      = aws_subnet.aws_cloud_private.id
  route_table_id = aws_route_table.aws_cloud_private.id
}