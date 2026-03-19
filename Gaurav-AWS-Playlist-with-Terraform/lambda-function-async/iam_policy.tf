# Allow Lambda service in this account to publish to the failure topic
resource "aws_sns_topic_policy" "lambda_failure" {
  arn = aws_sns_topic.failure.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action   = "sns:Publish"
      Resource = aws_sns_topic.failure.arn
      Condition = {
        StringEquals = {
          "aws:SourceAccount" = data.aws_caller_identity.current.account_id
        }
      }
    }]
  })
}