# VPC Endpoints Demo Configuration
#
# IMPORTANT: After deployment, SSH to the demo instances and run these commands
# before testing AWS CLI to avoid hanging issues:
#
#   export AWS_DEFAULT_REGION=ap-south-1
#   export AWS_EC2_METADATA_SERVICE_ENDPOINT_MODE=IPv4
#   export AWS_EC2_METADATA_SERVICE_ENDPOINT=http://169.254.169.254
#
# Testing Commands:
#   Gateway Demo (S3):     aws s3 ls
#   Interface Demo (EC2):  aws ec2 describe-instances
#   IPv6 Demo (EIGW):      ping6 2606:4700:4700::1111

# Gateway endpoints for S3

resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.private_gateway.id
  ]

  tags = {
    Name = "S3-Gateway-Endpoint"
  }
}

# Interface endpoint for EC2

resource "aws_vpc_endpoint" "ec2_interface" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type = "Interface"
  subnet_ids = [aws_subnet.private_interface.id]
  security_group_ids = [aws_security_group.vpc_endpoint.id]

  private_dns_enabled = true

  tags = {
    Name = "EC2-Interface-Endpoint"
  }
}           