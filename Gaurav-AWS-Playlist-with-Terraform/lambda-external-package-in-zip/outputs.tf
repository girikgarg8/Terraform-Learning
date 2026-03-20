output "lambda_function_name" {
  description = "Invoke this function to verify requests + httpbin call"
  value       = aws_lambda_function.with_requests_zip.function_name
}
