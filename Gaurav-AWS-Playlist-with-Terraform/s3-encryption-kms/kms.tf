resource "aws_kms_key" "s3" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "s3" {
  name          = var.kms_key_alias
  target_key_id = aws_kms_key.s3.key_id
}
