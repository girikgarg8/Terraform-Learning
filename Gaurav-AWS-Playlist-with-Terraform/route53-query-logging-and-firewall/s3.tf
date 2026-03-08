resource "aws_s3_bucket" "resolver_logs" {
  bucket = var.query_log_bucket_name
  tags = {
    Name = var.query_log_bucket_name
  }
}

resource "aws_s3_bucket_versioning" "resolver_logs" {
  bucket = aws_s3_bucket.resolver_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Policy matching AWS console: Resolver query logs to S3 go via delivery.logs.amazonaws.com (CloudWatch Logs pipeline)
resource "aws_s3_bucket_policy" "resolver_logs" {
  bucket = aws_s3_bucket.resolver_logs.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "AWSLogDeliveryWrite20150319"
    Statement = [
      {
        Sid    = "AWSLogDeliveryWrite1"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.resolver_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
            "s3:x-amz-acl"      = "bucket-owner-full-control"
          }
          ArnLike = {
            "aws:SourceArn" = "arn:${data.aws_partition.current.partition}:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
          }
        }
      },
      {
        Sid    = "AWSLogDeliveryAclCheck1"
        Effect = "Allow"
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.resolver_logs.arn
        Condition = {
          StringEquals = { "aws:SourceAccount" = data.aws_caller_identity.current.account_id }
          ArnLike      = { "aws:SourceArn" = "arn:${data.aws_partition.current.partition}:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*" }
        }
      }
    ]
  })
}