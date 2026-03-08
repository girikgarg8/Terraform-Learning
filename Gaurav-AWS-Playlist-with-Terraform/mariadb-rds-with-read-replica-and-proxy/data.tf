data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_kms_key" "rds_pi" {
  key_id = "alias/aws/rds"
}