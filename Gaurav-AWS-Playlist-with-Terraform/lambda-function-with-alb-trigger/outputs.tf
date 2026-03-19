output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer (open http://<dns>/ in a browser)"
  value       = aws_lb.main.dns_name
}

output "lambda_function_name" {
  description = "Lambda function registered as ALB target"
  value       = aws_lambda_function.alb_target.function_name
}
