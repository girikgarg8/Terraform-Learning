resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name = "/aws/vpc/flowlogs"
  retention_in_days = 7

  tags = {
    Name = "VPC Flow logs"
  }
}

# IAM role for Cloudwatch flow logs

resource "aws_iam_role" "vpc_flow_logs_cloudwatch_role" {
  name = "vpc-flow-logs-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                "Service" = "vpc-flow-logs.amazonaws.com"
            }
        }
    ]
  })

  tags = {
    Name = "VPC Flow Logs IAM Role"
  }
}

# IAM Policy for CloudWatch Logs
resource "aws_iam_role_policy" "vpc_flow_logs_policy" {
  name = "vpc-flow-logs-cloudwatch-policy"
  role = aws_iam_role.vpc_flow_logs_cloudwatch_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
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

# VPC Flow Logs for VPC1
resource "aws_flow_log" "vpc1_cloudwatch_flow_log" {
  iam_role_arn    = aws_iam_role.vpc_flow_logs_cloudwatch_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc1.id

  tags = {
    Name = "VPC1 Flow Logs"
  }
}

# VPC Flow Logs for VPC2
resource "aws_flow_log" "vpc2_cloudwatch_flow_log" {
  iam_role_arn    = aws_iam_role.vpc_flow_logs_cloudwatch_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc2.id

  tags = {
    Name = "VPC2 Flow Logs"
  }
}