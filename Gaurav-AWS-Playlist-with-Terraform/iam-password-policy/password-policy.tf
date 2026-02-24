resource "aws_iam_account_password_policy" "custom" {
  minimum_password_length = 8
  require_uppercase_characters = true
  require_lowercase_characters = true
  require_numbers = true
  max_password_age = 30
}