# Bastion host in public subnet
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.bastion.id]
  key_name               = var.key_name

  tags = {
    Name = "Bastion-Host"
  }
}

# Instance for Gateway endpoint testing (S3 access)
# NOTE: After SSH to this instance, run these commands before testing S3:
#   export AWS_DEFAULT_REGION=ap-south-1
#   export AWS_EC2_METADATA_SERVICE_ENDPOINT_MODE=IPv4
#   export AWS_EC2_METADATA_SERVICE_ENDPOINT=http://169.254.169.254
#   aws s3 ls  # Should work via VPC Gateway endpoint
resource "aws_instance" "gateway_demo" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_gateway.id
  vpc_security_group_ids = [aws_security_group.private.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.s3_demo_profile.name

  tags = {
    Name = "Gateway-Endpoint-Demo-S3"
  }
}

# Instance for Interface endpoint testing (EC2 API access)
# NOTE: After SSH to this instance, run these commands before testing EC2 API:
#   export AWS_DEFAULT_REGION=ap-south-1
#   export AWS_EC2_METADATA_SERVICE_ENDPOINT_MODE=IPv4
#   export AWS_EC2_METADATA_SERVICE_ENDPOINT=http://169.254.169.254
#   aws ec2 describe-instances  # Should work via VPC Interface endpoint
resource "aws_instance" "interface_demo" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_interface.id
  vpc_security_group_ids = [aws_security_group.private.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_demo_profile.name

  tags = {
    Name = "Interface-Endpoint-Demo-EC2"
  }
}

# IPv6-only instance for EIGW testing
resource "aws_instance" "ipv6_demo" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.ipv6_only.id
  vpc_security_group_ids = [aws_security_group.ipv6.id]
  key_name               = var.key_name

  # Only assign IPv6 address
  associate_public_ip_address = false

  tags = {
    Name = "IPv6-EIGW-Demo"
  }
}