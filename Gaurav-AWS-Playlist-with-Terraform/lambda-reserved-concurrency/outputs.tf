output "function_url" {
  description = "Public function URL for reserved concurrency demo"
  value       = aws_lambda_function_url.demo_reserved.function_url
}

output "function_name" {
  value = aws_lambda_function.demo_reserved.function_name
}
