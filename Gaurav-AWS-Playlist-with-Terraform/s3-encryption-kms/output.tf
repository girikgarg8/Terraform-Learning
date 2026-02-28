output "bucket_name" {
  value       = aws_s3_bucket.main.id
  description = "Name of the encrypted S3 bucket"
}

output "kms_key_arn" {
  value       = aws_kms_key.s3.arn
  description = "ARN of the KMS key used for bucket encryption"
}

output "kms_key_alias" {
  value       = aws_kms_alias.s3.name
  description = "Alias of the KMS key"
}
