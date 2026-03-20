output "function_url" {
  description = "Invoke this URL to test outbound access from Lambda in private subnet with NAT"
  value       = aws_lambda_function_url.demo.function_url
}

output "lambda_function_name" {
  value = aws_lambda_function.demo.function_name
}
