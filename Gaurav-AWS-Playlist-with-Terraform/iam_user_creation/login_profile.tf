resource "aws_iam_user_login_profile" "sample" {
  user = aws_iam_user.sample.name
  password_length = 20
  password_reset_required = true
}