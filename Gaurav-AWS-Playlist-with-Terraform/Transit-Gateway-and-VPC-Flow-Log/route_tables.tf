# Route table for VPC1

resource "aws_route_table" "vpc1_public" {
  vpc_id = aws_vpc.vpc1.id

  # Internet route
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc1_igw.id
  }

  # Route to VPC2 via Transit Gateway

  route {
    cidr_block = "10.2.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  tags = {
    Name = "vpc1-public-rt"
  }
}

# Route table for VPC2

resource "aws_route_table" "vpc2_public" {
  vpc_id = aws_vpc.vpc2.id

  # Internet route
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc2_igw.id
  }

  # Route to VPC1 via Transit Gateway
  route {
    cidr_block = "10.1.0.0/16"
    transit_gateway_id = aws_ec2_transit_gateway.main.id
  }

  tags = {
    Name = "vpc2-public-rt"
  }
}

# Associate route table with subnets

resource "aws_route_table_association" "vpc1_public" {
  subnet_id = aws_subnet.vpc1_public.id
  route_table_id = aws_route_table.vpc1_public.id
}

resource "aws_route_table_association" "vpc2_public" {
  subnet_id = aws_subnet.vpc2_public.id
  route_table_id = aws_route_table.vpc2_public.id
}