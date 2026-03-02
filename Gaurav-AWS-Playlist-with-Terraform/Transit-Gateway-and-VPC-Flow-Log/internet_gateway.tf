resource "aws_internet_gateway" "vpc1_igw" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "vpc1-igw"
  }
}

resource "aws_internet_gateway" "vpc2_igw" {
  vpc_id = aws_vpc.vpc2.id
  tags = {
    Name = "vpc2-igw"
  }
}