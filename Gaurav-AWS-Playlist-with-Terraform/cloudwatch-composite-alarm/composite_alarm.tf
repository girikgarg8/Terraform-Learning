resource "aws_cloudwatch_composite_alarm" "main" {
  alarm_name        = "ec2-cpu-or-status-composite"
  alarm_description = "Fires when CPU > 30% OR instance status check fails"
  actions_enabled   = true
  alarm_actions      = [data.aws_sns_topic.composite_alarm.arn]

  alarm_rule = "ALARM(${aws_cloudwatch_metric_alarm.cpu_high.alarm_name}) OR ALARM(${aws_cloudwatch_metric_alarm.status_check_failed.alarm_name})"
}