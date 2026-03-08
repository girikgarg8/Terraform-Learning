data "aws_vpc" "default" {
  default = true
}

# No arguments required; provider returns account_id, arn, user_id from current credentials
data "aws_caller_identity" "current" {}

# No arguments required; provider returns partition (e.g. "aws", "aws-cn", "aws-us-gov")
data "aws_partition" "current" {}