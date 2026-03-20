output "function_name" {
  value = aws_lambda_function.add_two_numbers.function_name
}

output "function_arn" {
  value = aws_lambda_function.add_two_numbers.arn
}

output "sns_topic_arn" {
  value       = data.aws_sns_topic.mysampletopic.arn
  description = "Success async invocations publish invocation records here"
}
