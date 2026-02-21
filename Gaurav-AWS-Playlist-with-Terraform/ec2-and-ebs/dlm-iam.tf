# DLM = Data lifecycle manager
resource "aws_iam_role" "dlm_lifecycle" {
    name = "dlm-ebs-lifecycle-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "dlm.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_role_policy" "dlm_lifecycle" {
    name = "dlm-ebs-lifecycle-policy"
    role = aws_iam_role.dlm_lifecycle.id
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "ec2:CreateSnapshot",
                    "ec2:DeleteSnapshot",
                    "ec2:DescribeVolumes",
                    "ec2:DescribeSnapshots",
                    "ec2:DescribeTags"
                ]
                Resource = "*"
            },
            {   
                Effect = "Allow"
                Action = "ec2:CreateTags"
                Resource = "arn:aws:ec2:*::snapshot/*"
            }
        ]
    })
}