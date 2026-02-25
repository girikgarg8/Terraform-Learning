resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  # Redirect documents/* -> docs/*
  routing_rule {
    condition {
      key_prefix_equals = "documents/"
    }
    redirect {
      replace_key_prefix_with = "docs/"
      protocol                 = "http"
    }
  }
}