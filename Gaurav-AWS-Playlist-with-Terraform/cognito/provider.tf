provider "aws" {
  region = var.aws_region
}

# ACM for Cognito custom domains must be in us-east-1
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}