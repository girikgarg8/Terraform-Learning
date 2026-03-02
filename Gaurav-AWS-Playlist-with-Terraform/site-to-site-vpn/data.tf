# Data sources for AMI lookup in both regions
data "aws_ami" "amazon_linux_on_premises" {
  provider    = aws.on_premises
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "amazon_linux_aws_cloud" {
  provider    = aws.aws_cloud
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Availability zones
data "aws_availability_zones" "on_premises_azs" {
  provider = aws.on_premises
  state    = "available"
}

data "aws_availability_zones" "aws_cloud_azs" {
  provider = aws.aws_cloud
  state    = "available"
}