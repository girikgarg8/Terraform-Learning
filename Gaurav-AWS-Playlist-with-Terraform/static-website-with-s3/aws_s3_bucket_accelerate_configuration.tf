resource "aws_s3_bucket_accelerate_configuration" "website" {
  bucket = aws_s3_bucket.website.id
  status = "Enabled"
}