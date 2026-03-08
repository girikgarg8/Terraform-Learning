resource "aws_security_group" "inbound_resolver" {
  name_prefix = "resolver-inbound-"
  vpc_id = aws_vpc.test.id
  description = "Allow DNS from default VPC to Resolver inbound endpoint"

  ingress {
    from_port = 53
    to_port = 53
    protocol = "udp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_resolver_endpoint" "inbound" {
  name = "test-vpc-inbound"
  direction = "INBOUND"
  security_group_ids = [aws_security_group.inbound_resolver.id]

  ip_address {
    subnet_id = aws_subnet.test_a.id
  }

  ip_address {
    subnet_id = aws_subnet.test_b.id
  }

  tags = {
    Name = "test-vpc-inbound"
  }
}