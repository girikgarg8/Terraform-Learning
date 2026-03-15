resource "aws_cloudwatch_log_metric_filter" "error" {
  name = "error-logs"
  log_group_name = aws_cloudwatch_log_group.agent.name
  pattern = "?error ?ERROR"
  metric_transformation {
    name = "ErrorLogCount"
    namespace = var.metrics_namespace
    value = "1"
    default_value = "0"
  }
}