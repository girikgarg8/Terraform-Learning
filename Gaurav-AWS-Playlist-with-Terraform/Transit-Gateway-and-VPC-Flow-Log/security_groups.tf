resource "aws_security_group" "vpc1_sg" {
  name = "vpc1-instance-sg"
  description = "Security group for VPC1 instance"
  vpc_id = aws_vpc.vpc1.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   }

  tags = {
    Name = "vpc1-instance-sg"
  }
}

resource "aws_security_group" "vpc2_sg" {
  name = "vpc2-instance-sg"
  description = "Security group for VPC2 instance"
  vpc_id = aws_vpc.vpc2.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
   }

  tags = {
    Name = "vpc2-instance-sg"
  }
}

