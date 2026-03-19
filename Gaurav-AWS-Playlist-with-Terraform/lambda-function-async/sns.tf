resource "aws_sns_topic" "failure" {
  name = var.sns_topic_name
}
