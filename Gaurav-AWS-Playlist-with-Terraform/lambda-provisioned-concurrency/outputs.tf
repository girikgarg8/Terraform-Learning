output "function_name" {
  value = aws_lambda_function.demo_provisioned.function_name
}

output "alias_name" {
  value = aws_lambda_alias.live.name
}

output "alias_invoke_arn" {
  description = "Invoke with qualifier \"live\" (provisioned applies here after config is active)"
  value       = aws_lambda_alias.live.invoke_arn
}
