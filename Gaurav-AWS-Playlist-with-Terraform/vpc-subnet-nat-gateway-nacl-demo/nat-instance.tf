resource "aws_security_group" "nat_instance" {
  name_prefix = "nat-instance-"
  vpc_id = aws_vpc.main.id
  # From private subnet (outbound-initiated traffic)
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.private1_subnet_cidr]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = [var.private1_subnet_cidr]
  }
  # Return traffic from internet (required for NAT to work)
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_instance" "nat_instance" {
  ami = data.aws_ami.fck_nat.id
  instance_type = var.nat_instance_type
  subnet_id = aws_subnet.public.id
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.nat_instance.id]
  source_dest_check = false
  associate_public_ip_address = true
  tags = {
    Name = "nat-instance"
  }
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = aws_instance.nat_instance.primary_network_interface_id
  }

  tags = {
    Name = "private1"
  }
}

resource "aws_route_table_association" "private1" {
  subnet_id = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}