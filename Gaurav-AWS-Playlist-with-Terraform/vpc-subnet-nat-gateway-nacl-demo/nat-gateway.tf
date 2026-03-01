resource "aws_eip" "nat_gw" {
  domain = "vpc"
  tags = {
    Name = "nat-gw-eip"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id = aws_subnet.public.id
  tags = {
    Name = "main-nat-gw"
  }
  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.main.id
  route  {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }
  tags = {
    Name = "private2"
  }
}

resource "aws_route_table_association" "private2" {
  subnet_id = aws_subnet.private2.id
  route_table_id = aws_route_table.private2.id
}