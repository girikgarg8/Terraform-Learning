resource "aws_iam_instance_profile" "ec2_full_access" {
  name = "ec2-full-access-instance-profile"
  role = aws_iam_role.ec2_full_access.name
}