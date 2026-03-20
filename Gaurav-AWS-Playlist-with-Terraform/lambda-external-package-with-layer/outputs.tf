output "layer_arn" {
  description = "Published layer version ARN"
  value       = aws_lambda_layer_version.requests.arn
}

output "lambda_function_name" {
  description = "Function using the requests layer"
  value       = aws_lambda_function.with_requests_layer.function_name
}
