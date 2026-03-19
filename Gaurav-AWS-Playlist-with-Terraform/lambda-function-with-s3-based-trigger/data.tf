data "aws_s3_bucket" "trigger_bucket" {
  bucket = var.s3_trigger_bucket_name
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/index.py"
  output_path = "${path.module}/s3_trigger.zip"
}
