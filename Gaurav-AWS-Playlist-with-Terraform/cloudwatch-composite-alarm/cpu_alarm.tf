resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name = "ec2-cpu-above-30"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 60
  statistic = "Average"
  threshold = 30

  dimensions = {
    InstanceId = aws_instance.main.id
  }

  alarm_description = "CPU Utilization above 30%"
}