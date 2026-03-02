# Egress only Internet Gateway

resource "aws_egress_only_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Main-EIGW"
  }
}