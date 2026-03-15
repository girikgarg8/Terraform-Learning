resource "aws_cloudwatch_metric_alarm" "billing" {
  provider = aws.us-east-1
  alarm_name = "billing-estimated-charges"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 1
  metric_name = "EstimatedCharges"
  namespace = "AWS/Billing"
  period = 86400 # 24 hours
  statistic = "Maximum"
  threshold = var.billing_alarm_threshold_usd
  alarm_description = "Estimated charges exceed ${var.billing_alarm_threshold_usd} USD"

  dimensions = {
    "Currency" = "USD"
  }

  alarm_actions = [aws_sns_topic.billing.arn]
}