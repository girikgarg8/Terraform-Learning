resource "aws_vpc" "test" {
  cidr_block = var.test_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "test-vpc"
  }
}

resource "aws_subnet" "test_a" {
  vpc_id = aws_vpc.test.id
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "test-a"
  }
}

resource "aws_subnet" "test_b" {
  vpc_id = aws_vpc.test.id
  cidr_block = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "test-b"
  }
}

resource "aws_vpc_peering_connection" "default_to_test" {
  vpc_id = data.aws_vpc.default.id
  peer_vpc_id = aws_vpc.test.id
  auto_accept = true
  tags = {
    Name = "default-to-test"
  }
}

resource "aws_route" "default_to_test" {
  route_table_id            = data.aws_vpc.default.main_route_table_id
  destination_cidr_block   = var.test_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default_to_test.id
}

resource "aws_route" "test_to_default" {
  route_table_id            = aws_vpc.test.main_route_table_id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default_to_test.id
}