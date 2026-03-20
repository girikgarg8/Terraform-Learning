data "aws_sns_topic" "mysampletopic" {
  name = var.sns_topic_name
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/index.py"
  output_path = "${path.module}/lambda_destination.zip"
}
