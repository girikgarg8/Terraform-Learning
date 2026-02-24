resource "aws_iam_user_policy_attachment" "ec2_full_access" {
  user       = aws_iam_user.sample.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# Allow user to change their own password (self-service)
resource "aws_iam_user_policy_attachment" "change_own_password" {
  user       = aws_iam_user.sample.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}