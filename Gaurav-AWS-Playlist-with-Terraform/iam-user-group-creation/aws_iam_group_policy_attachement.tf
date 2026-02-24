resource "aws_iam_group_policy_attachment" "ec2_full_access" {
    group = aws_iam_group.ec2_full_access.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}