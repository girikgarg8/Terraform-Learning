data "aws_ami" "amazon_linux_aps1" {
  provider = aws.aps1
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "amazon_linux_usw2" {
  provider = aws.usw2
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# AWS managed prefix list for ap-south-1 (S3 endpoints in region - used as proxy for region CIDRs)
# Lookup must run in the same region where the prefix list exists.
data "aws_ec2_managed_prefix_list" "ap_south_1" {
  provider = aws.aps1
  filter {
    name   = "prefix-list-name"
    values = ["com.amazonaws.ap-south-1.s3"]
  }
}

# AWS managed prefix list for us-west-2
data "aws_ec2_managed_prefix_list" "us_west_2" {
  provider = aws.usw2
  filter {
    name   = "prefix-list-name"
    values = ["com.amazonaws.us-west-2.s3"]
  }
}