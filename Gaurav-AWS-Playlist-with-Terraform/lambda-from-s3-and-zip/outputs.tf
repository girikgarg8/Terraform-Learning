output "s3_bucket_id" {
  description = "Bucket holding the Lambda deployment zip"
  value       = aws_s3_bucket.lambda_code.id
}

output "lambda_from_zip_name" {
  value = aws_lambda_function.from_zip.function_name
}

output "lambda_from_s3_name" {
  value = aws_lambda_function.from_s3.function_name
}
