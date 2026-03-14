# SNS topic
resource "aws_sns_topic" "main" {
  name = var.topic_name
}

# Email subscription (recipient must confirm via the confirmation email)
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.main.arn
  protocol  = "email"
  endpoint  = var.email_endpoint
}

# SMS subscription
resource "aws_sns_topic_subscription" "sms" {
  topic_arn = aws_sns_topic.main.arn
  protocol  = "sms"
  endpoint  = var.sms_endpoint
}

# HTTPS subscription (endpoint must confirm by responding to SNS subscription confirmation)
resource "aws_sns_topic_subscription" "https" {
  topic_arn = aws_sns_topic.main.arn
  protocol  = "https"
  endpoint  = var.https_endpoint
}
