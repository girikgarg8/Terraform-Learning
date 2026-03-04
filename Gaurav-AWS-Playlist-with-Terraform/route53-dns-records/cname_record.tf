resource "aws_route53_record" "s3_cname" {
  zone_id = aws_route53_zone.main.zone_id
  name = "tests3bucket.girikgarg.xyz"
  type = "CNAME"
  ttl = 300
  records = [aws_s3_bucket_website_configuration.static_website_config.website_endpoint]
}