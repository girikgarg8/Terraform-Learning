resource "aws_route53_resolver_query_log_config" "default_vpc" {
  name = "default-vpc-query-logs"
  destination_arn = aws_s3_bucket.resolver_logs.arn
  tags = {
    Name = "default-vpc-query-logs"
  }
}

resource "aws_route53_resolver_query_log_config_association" "default_vpc" {
  resolver_query_log_config_id = aws_route53_resolver_query_log_config.default_vpc.id
  resource_id                  = data.aws_vpc.default.id
  # Ensure bucket policy is applied before Resolver tries to use the destination
  depends_on = [aws_s3_bucket_policy.resolver_logs]
}