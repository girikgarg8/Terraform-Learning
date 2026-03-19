output "sns_topic_arn" {
  description = "SNS topic ARN for async failure notifications"
  value       = aws_sns_topic.failure.arn
}

output "lambda_function_name" {
  description = "Name of the async-error Lambda function"
  value       = aws_lambda_function.async_error.function_name
}
