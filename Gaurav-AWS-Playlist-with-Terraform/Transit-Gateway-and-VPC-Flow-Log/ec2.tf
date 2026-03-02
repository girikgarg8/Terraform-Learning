# EC2 Instance in VPC1
resource "aws_instance" "vpc1_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.vpc1_public.id
  vpc_security_group_ids = [aws_security_group.vpc1_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "VPC1-Instance"
  }
}

# EC2 Instance in VPC2
resource "aws_instance" "vpc2_instance" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.vpc2_public.id
  vpc_security_group_ids = [aws_security_group.vpc2_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "VPC2-Instance"
  }
}