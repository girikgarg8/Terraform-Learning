resource "aws_iam_role" "ec2_full_access" {
  name = "ec2-full-access-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ec2_full_access" {
    role = aws_iam_role.ec2_full_access.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}