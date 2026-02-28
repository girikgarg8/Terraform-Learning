resource "aws_cloudfront_distribution" "main" {
  enabled = true
  comment = "Dual origin: docs -> S3, api -> EC2"
  default_root_object = "index.html"

  # Origin 1: S3 (for docs/*)
  origin {
    domain_name = var.s3_bucket_domain
    origin_id = "s3-origin"

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  # Origin 2: EC2 (for api/*)
  origin {
    domain_name = var.ec2_origin_domain
    origin_id = "ec2-origin"

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  # Default: S3
    default_cache_behavior {
      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods = ["GET", "HEAD"]
      target_origin_id = "s3-origin"
      viewer_protocol_policy = "redirect-to-https"
      compress = true

      forwarded_values {
        query_string = false
        cookies {
          forward = "none"
        }
      }
    }

    # docs/* -> S3
    ordered_cache_behavior {
      path_pattern = "/docs/*"
      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods = ["GET", "HEAD"]
      target_origin_id = "s3-origin"
      viewer_protocol_policy = "redirect-to-https"
      compress = true

      forwarded_values {
        query_string = false
        cookies {
          forward = "none"
        }
      }
    }

    # api/* -> EC2 (no or short cache)
    ordered_cache_behavior {
      path_pattern = "/api/*"
      allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
      cached_methods = ["GET", "HEAD"]
      target_origin_id = "ec2-origin"
      viewer_protocol_policy = "redirect-to-https"
      compress = false
      min_ttl = 0
      max_ttl = 0
      default_ttl = 0

      forwarded_values {
        query_string = true
        headers = ["*"]
        cookies {
          forward = "all"
        }
      }
    }

    # Custom 404: serve error.html 
    custom_error_response {
      error_code = 404
      response_code = 404
      response_page_path = "/docs/error.html"
      error_caching_min_ttl = 10
    }

    # Whitelist only India for accessing the Cloudfront distribution
    restrictions {
      geo_restriction {
        restriction_type = "whitelist"
        locations = ["IN"]
      }
    }

    viewer_certificate {
      cloudfront_default_certificate = true
    }
}