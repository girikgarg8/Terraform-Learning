resource "aws_cloudwatch_metric_alarm" "status_check_failed" {
  alarm_name = "ec2-status-check-failed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name = "StatusCheckFailed_Instance"
  namespace = "AWS/EC2"
  period = 60
  statistic = "Maximum"
  threshold = 1

  dimensions = {
    InstanceId = aws_instance.main.id
  }

  alarm_description = "Instance status check failed"
}