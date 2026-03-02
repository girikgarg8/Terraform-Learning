# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main-IGW"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "Public-RT"
  }
}

# Private Route Table for Gateway Demo
resource "aws_route_table" "private_gateway" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Private-Gateway-RT"
  }
}

# Private Route Table for Interface Demo
resource "aws_route_table" "private_interface" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Private-Interface-RT"
  }
}

# IPv6 Route Table
resource "aws_route_table" "ipv6" {
  vpc_id = aws_vpc.main.id

  # IPv6 outbound via EIGW
  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.main.id
  }

  tags = {
    Name = "IPv6-RT"
  }
}

# Route Table Associations
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_gateway" {
  subnet_id      = aws_subnet.private_gateway.id
  route_table_id = aws_route_table.private_gateway.id
}

resource "aws_route_table_association" "private_interface" {
  subnet_id      = aws_subnet.private_interface.id
  route_table_id = aws_route_table.private_interface.id
}

resource "aws_route_table_association" "ipv6" {
  subnet_id      = aws_subnet.ipv6_only.id
  route_table_id = aws_route_table.ipv6.id
}