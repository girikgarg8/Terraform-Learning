resource "aws_security_group" "app" {
  name_prefix = "app-"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
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

resource "aws_instance" "public" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public.id
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.app.id]
  tags = {
    Name = "public"
  }
}

resource "aws_instance" "private1" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.private1.id
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.app.id]
  tags = {
    Name = "private1"
  }
}

resource "aws_instance" "private2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.private2.id
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.app.id]
  tags = {
    Name = "private2"
  }
}