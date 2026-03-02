# Security Group for On-Premises Instance (ap-south-1)
resource "aws_security_group" "on_premises_sg" {
  provider    = aws.on_premises
  name        = "on-premises-sg"
  description = "Security group for on-premises instance (Libreswan)"
  vpc_id      = aws_vpc.on_premises.id

  # SSH access from internet
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  # ICMP from AWS Cloud VPC
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.aws_cloud_cidr]
    description = "ICMP from AWS Cloud VPC"
  }

  # ICMP from local VPC
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.on_premises_cidr]
    description = "ICMP from local VPC"
  }

  # IPsec traffic (ESP)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "50"
    cidr_blocks = ["0.0.0.0/0"]
    description = "IPsec ESP"
  }

  # IPsec traffic (AH)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "51"
    cidr_blocks = ["0.0.0.0/0"]
    description = "IPsec AH"
  }

  # IKE traffic
  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "IKE"
  }

  # NAT-T traffic
  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "NAT-T"
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name = "On-Premises-SG"
  }
}

# Security Group for AWS Cloud Instance (ap-south-2)
resource "aws_security_group" "aws_cloud_sg" {
  provider    = aws.aws_cloud
  name        = "aws-cloud-sg"
  description = "Security group for AWS cloud instance"
  vpc_id      = aws_vpc.aws_cloud.id

  # SSH from on-premises VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.on_premises_cidr]
    description = "SSH from on-premises"
  }

  # SSH from bastion host in same VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.2.0/24"]
    description = "SSH from bastion subnet"
  }

  # ICMP from on-premises VPC
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.on_premises_cidr]
    description = "ICMP from on-premises"
  }

  # ICMP from local VPC
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.aws_cloud_cidr]
    description = "ICMP from local VPC"
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name = "AWS-Cloud-SG"
  }
}

# Security Group for AWS Cloud Bastion (ap-south-2)
resource "aws_security_group" "aws_cloud_bastion_sg" {
  provider    = aws.aws_cloud
  name        = "aws-cloud-bastion-sg"
  description = "Security group for AWS cloud bastion"
  vpc_id      = aws_vpc.aws_cloud.id

  # SSH from internet
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name = "AWS-Cloud-Bastion-SG"
  }
}