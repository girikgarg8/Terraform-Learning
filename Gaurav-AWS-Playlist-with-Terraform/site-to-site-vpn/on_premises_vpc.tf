# On-Premises VPC (ap-south-1) - Simulates customer data center
resource "aws_vpc" "on_premises" {
  provider   = aws.on_premises
  cidr_block = var.on_premises_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "On-Premises-VPC"
    Type = "Simulated-DataCenter"
  }
}

# Public subnet for on-premises instance (simulates DMZ)
resource "aws_subnet" "on_premises_public" {
  provider                = aws.on_premises
  vpc_id                  = aws_vpc.on_premises.id
  cidr_block              = "172.31.1.0/24"
  availability_zone       = data.aws_availability_zones.on_premises_azs.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "On-Premises-Public-Subnet"
    Type = "DMZ-Simulation"
  }
}

# Internet Gateway for on-premises VPC
resource "aws_internet_gateway" "on_premises_igw" {
  provider = aws.on_premises
  vpc_id   = aws_vpc.on_premises.id

  tags = {
    Name = "On-Premises-IGW"
  }
}

# Route table for on-premises public subnet
resource "aws_route_table" "on_premises_public" {
  provider = aws.on_premises
  vpc_id   = aws_vpc.on_premises.id

  # Internet route
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.on_premises_igw.id
  }

  tags = {
    Name = "On-Premises-Public-RT"
  }
}

# Associate route table with public subnet
resource "aws_route_table_association" "on_premises_public" {
  provider       = aws.on_premises
  subnet_id      = aws_subnet.on_premises_public.id
  route_table_id = aws_route_table.on_premises_public.id
}