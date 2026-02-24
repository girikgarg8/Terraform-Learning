resource "aws_iam_user_group_membership" "user1" {
  user = aws_iam_user.user1.name
  groups = [aws_iam_group.ec2_full_access.name]
}