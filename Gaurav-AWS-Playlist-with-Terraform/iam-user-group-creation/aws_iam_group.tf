resource "aws_iam_group" "ec2_full_access" {
  name = "ec2-full-access-user-group"
  path = "/"
}