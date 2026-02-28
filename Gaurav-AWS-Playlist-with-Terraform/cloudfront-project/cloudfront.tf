# CloudFront distribution with EC2 as origin, custom header, cache policy, price class
resource "aws_cloudfront_distribution" "app" {
  enabled             = true
  comment             = "Demo: EC2 origin, custom header, query-string cache policy"
  default_root_object = ""
  price_class         = var.price_class

  origin {
    domain_name = aws_instance.app.public_dns
    origin_id   = "ec2-origin"

    custom_header {
      name  = var.origin_custom_header_name
      value = var.origin_custom_header_value
    }

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "ec2-origin"
    cache_policy_id       = aws_cloudfront_cache_policy.api.id
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods       = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods        = ["GET", "HEAD"]
    compress              = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
