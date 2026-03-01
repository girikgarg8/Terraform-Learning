resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id

  subnet_ids = [aws_subnet.public.id]

  tags = {
    Name = "public-nacl"
  }
}

resource "aws_network_acl_rule" "public_inbound_all" {
  network_acl_id = aws_network_acl.public.id
  rule_number = 100
  rule_action = "allow"
  protocol = "-1"
  cidr_block = "0.0.0.0/0"
  from_port = 0
  to_port = 0
}

resource "aws_network_acl_rule" "public_outbound_all" {
  network_acl_id = aws_network_acl.public.id
  rule_number = 100
  rule_action = "allow"
  protocol = "-1"
  cidr_block = "0.0.0.0/0"
  from_port = 0
  to_port = 0
  egress = true
}