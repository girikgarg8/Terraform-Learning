output "lambda_function_name" {
  description = "Name of the S3-trigger Lambda function"
  value       = aws_lambda_function.s3_trigger.function_name
}

output "trigger_bucket_name" {
  description = "S3 bucket that triggers the Lambda"
  value       = data.aws_s3_bucket.trigger_bucket.id
}
