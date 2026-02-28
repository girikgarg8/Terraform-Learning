data "aws_ec2_managed_prefix_list" "cloudfront" {
  filter {
    name = "prefix-list-name"
    values = ["com.amazonaws.global.cloudfront.origin-facing"]
  }
}