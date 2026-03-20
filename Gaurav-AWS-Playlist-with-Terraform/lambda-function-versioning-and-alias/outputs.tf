output "function_url_test" {
  description = "Function URL for alias \"test\" (latest published version)"
  value       = aws_lambda_function_url.test.function_url
}

output "function_url_prod" {
  description = "Function URL for alias \"prod\" (pinned version via var.prod_alias_version)"
  value       = aws_lambda_function_url.prod.function_url
}

output "latest_published_version" {
  description = "Current numeric version from $LATEST publish"
  value       = aws_lambda_function.versioned.version
}
