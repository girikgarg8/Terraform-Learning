# Bucket name must match the custom domain (Host header) for S3 website CNAME to work
resource "aws_s3_bucket" "static_website" {
  bucket = "tests3bucket.girikgarg.xyz"
}

resource "aws_s3_bucket_public_access_block" "static_website_pab" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "static_website_policy" {
  bucket = aws_s3_bucket.static_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Sid = "PublicReadGetObject"
            Effect = "Allow"
            Principal = "*"
            Action = "s3:GetObject"
            Resource = "${aws_s3_bucket.static_website.arn}/*"
        }
    ]
  })

  depends_on = [ aws_s3_bucket_public_access_block.static_website_pab ]
}

resource "aws_s3_bucket_website_configuration" "static_website_config" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.static_website.id 
  key = "index.html"
  content = "<html><body><h1> Hello world from S3! </h1></body></html>"
  content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.static_website.id 
  key = "error.html"
  content = "<html><body><h1> Sorry, something went wrong </h1></body></html>"
  content_type = "text/html"
}