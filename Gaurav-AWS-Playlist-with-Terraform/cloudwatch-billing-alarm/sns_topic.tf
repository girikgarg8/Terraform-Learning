resource "aws_sns_topic" "billing" {
  provider = aws.us-east-1
  name = var.sns_topic_name
}

resource "aws_sns_topic_subscription" "billing_email" {
  provider = aws.us-east-1
  topic_arn = aws_sns_topic.billing.arn
  protocol = "email"
  endpoint = var.sns_topic_email
}