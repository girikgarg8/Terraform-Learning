resource "aws_s3_bucket_logging" "main" {
  bucket = aws_s3_bucket.main.id

  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "logs/main-bucket/"

  depends_on = [aws_s3_bucket_policy.logs]
}