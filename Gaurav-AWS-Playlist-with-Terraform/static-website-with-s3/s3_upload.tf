resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.website.id
  key = "index.html"
  source = "${path.module}/index.html"
  content_type = "text/html"

  depends_on = [ aws_s3_bucket_policy.website ]
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.website.id
  key = "error.html"
  source = "${path.module}/error.html"
  content_type = "text/html"

  depends_on = [ aws_s3_bucket_policy.website ]
}

resource "aws_s3_object" "docs_index" {
  bucket       = aws_s3_bucket.website.id
  key          = "docs/index.html"
  source       = "${path.module}/docs/index.html"
  content_type = "text/html"

  depends_on = [aws_s3_bucket_policy.website]
}