# Security Group for Bastion Host
resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Bastion-SG"
  }
}

# Security Group for Private Instances
resource "aws_security_group" "private" {
  name        = "private-instances-sg"
  description = "Security group for private instances"
  vpc_id      = aws_vpc.main.id

  # SSH from bastion
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private-Instances-SG"
  }
}

# Security Group for VPC Endpoints
resource "aws_security_group" "vpc_endpoint" {
  name        = "vpc-endpoint-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.main.id

  # HTTPS from private subnets
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [
      "10.0.2.0/24",  # private_gateway subnet
      "10.0.3.0/24"   # private_interface subnet
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPC-Endpoint-SG"
  }
}

# Security Group for IPv6 Instance
resource "aws_security_group" "ipv6" {
  name        = "ipv6-instance-sg"
  description = "Security group for IPv6 instance"
  vpc_id      = aws_vpc.main.id

  # SSH from bastion (IPv4)
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  # All outbound IPv4
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # All outbound IPv6
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "IPv6-Instance-SG"
  }
}