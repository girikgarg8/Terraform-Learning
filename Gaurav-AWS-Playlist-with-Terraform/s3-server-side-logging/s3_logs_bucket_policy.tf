data "aws_iam_policy_document" "logs_allow_log_delivery" {
    statement {
      sid = "S3ServerAccessLogsPolicy"
      effect = "Allow"
      principals {
        type = "Service"
        identifiers = ["logging.s3.amazonaws.com"]
      }

      actions = ["s3:PutObject"]
      resources = ["${aws_s3_bucket.logs.arn}/*"]

      condition {
        test = "ArnLike"
        variable = "aws:SourceArn"
        values = [aws_s3_bucket.main.arn]
      }
    }
}

resource "aws_s3_bucket_policy" "logs" {
    bucket = aws_s3_bucket.logs.id
    policy = data.aws_iam_policy_document.logs_allow_log_delivery.json
}