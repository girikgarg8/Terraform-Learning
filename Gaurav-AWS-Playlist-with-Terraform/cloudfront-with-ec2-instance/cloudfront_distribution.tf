resource "aws_cloudfront_distribution" "main" {
  enabled = true
  comment = "Nginx origin"

  # Use EIP's public_dns so origin hostname resolves to the EIP. If we used
  # aws_instance.nginx.public_dns, the same apply creates instance (temp IP)
  # then EIP attach; instance state still has the old public_dns, so CloudFront
  # would get the wrong hostname (ec2-<temp-ip>... instead of ec2-<eip>...).
  depends_on = [aws_eip.nginx]

  origin {
    domain_name = aws_eip.nginx.public_dns
    origin_id   = "nginx-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "nginx-origin"
    viewer_protocol_policy = "allow-all"
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
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
