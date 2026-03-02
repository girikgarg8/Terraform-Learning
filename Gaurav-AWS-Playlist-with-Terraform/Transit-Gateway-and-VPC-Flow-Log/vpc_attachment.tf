# Attach VPC1 to Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc1" {
  subnet_ids = [aws_subnet.vpc1_public.id]
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "vpc1-tgw-attachment"
  }
}

# Attach VPC2 to Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc2" {
  subnet_ids = [aws_subnet.vpc2_public.id]
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id = aws_vpc.vpc2.id

  tags = {
    Name = "vpc2-tgw-attachment"
  }
}

