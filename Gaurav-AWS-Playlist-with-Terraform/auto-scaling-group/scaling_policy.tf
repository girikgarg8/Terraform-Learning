# Scale out when ASG average CPU > 30% (for stress demo)
resource "aws_autoscaling_policy" "cpu" {
  name                   = "cpu-above-30"
  autoscaling_group_name = aws_autoscaling_group.web.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 30.0
  }
}
