output "region" {
  value       = var.region
  description = "AWS region used by this stack"
}

output "lambda_function_name" {
  value       = aws_lambda_function.rds_connectivity.function_name
  description = "Use with get-function-url-config / get-policy"
}

output "lambda_function_url" {
  value       = aws_lambda_function_url.probe.function_url
  description = "GET this URL to verify TCP connectivity to RDS (lab only)"
}

output "rds_endpoint" {
  value       = aws_db_instance.main.endpoint
  description = "MySQL endpoint (host:port)"
}

output "rds_address" {
  value       = aws_db_instance.main.address
  description = "MySQL hostname"
}

output "db_name" {
  value = aws_db_instance.main.db_name
}

output "db_master_username" {
  value = aws_db_instance.main.username
}

output "db_master_password" {
  value     = random_password.db_master.result
  sensitive = true
}
