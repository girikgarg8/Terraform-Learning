# Upload local file to S3. pathexpand() expands ~ to your home directory.
resource "aws_s3_object" "upload" {
  bucket       = aws_s3_bucket.main.id
  key          = "1.avif"
  source       = pathexpand("~/S3-Sample-Data/1.avif")
  content_type = "image/avif"

  depends_on = [aws_s3_bucket_policy.main]
}
