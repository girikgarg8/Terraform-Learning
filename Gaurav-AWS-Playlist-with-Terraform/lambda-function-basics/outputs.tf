output "function_url" {
  description = "Lambda Function URL to call from Postman (use POST and JSON body e.g. {\"a\": 1, \"b\": 2})"
  value       = aws_lambda_function_url.add_two.function_url
}
