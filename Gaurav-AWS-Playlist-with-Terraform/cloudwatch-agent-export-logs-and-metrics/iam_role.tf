resource "aws_iam_role" "cw_agent" {
  name = "ec2-cloudwatch-agent-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow"
        Principal = {
            Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cw_agent" {
  role = aws_iam_role.cw_agent.name
  policy_arn = aws_iam_policy.cw_agent.arn
}

resource "aws_iam_instance_profile" "cw_agent" {
    name = "ec2-cloudwatch-agent-profile"
    role = aws_iam_role.cw_agent.name
}

resource "aws_iam_policy" "cw_agent" {
  name = "cloudwatch-agent-policy"
  description = "Allow Cloudwatch agent to push metrics and logs"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Action = ["cloudwatch:PutMetricData"]
            Resource = "*"
        },
        {
            Effect = "Allow"
            Action = [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams"
            ]
            Resource = "*"
        }
    ]
  })
}