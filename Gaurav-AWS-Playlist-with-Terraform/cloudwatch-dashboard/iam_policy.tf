resource "aws_iam_policy" "dashboard_view" {
  name = "${var.dashboard_name}-view"
  description = "Allow viewing the Cloudwatch dashboard"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "cloudwatch:ListDashboards"
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = "cloudwatch:GetDashboard"
        Resource = [
          "arn:aws:cloudwatch:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:dashboard/${var.dashboard_name}",
          "arn:aws:cloudwatch::${data.aws_caller_identity.current.account_id}:dashboard/${var.dashboard_name}"
        ]
      },
      {
        Effect   = "Allow"
        Action   = [
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "dashboard_view" {
  for_each = toset(var.dashboard_shared_iam_usernames)

  user = each.value
  policy_arn = aws_iam_policy.dashboard_view.arn
}