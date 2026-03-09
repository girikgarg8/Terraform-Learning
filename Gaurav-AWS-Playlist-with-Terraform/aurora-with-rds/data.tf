data "aws_vpc" "default_primary" {
    provider = aws.primary
    default = true
}

data "aws_subnets" "default_primary" {
    provider = aws.primary
    filter {
      name = "vpc-id"
      values = [data.aws_vpc.default_primary.id]
    }
}

data "aws_availability_zones" "replica" {
  provider = aws.replica
  state = "available"
}

# Default Aurora MySQL version for primary region (avoids invalid/deprecated version errors)
data "aws_rds_engine_version" "aurora_mysql" {
  provider    = aws.primary
  engine      = "aurora-mysql"
  default_only = true
}