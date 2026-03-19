resource "aws_lambda_function" "s3_trigger" {
  function_name   = "s3-trigger-demo"
  role            = aws_iam_role.lambda.arn
  handler         = "index.lambda_handler"
  runtime         = "python3.12"
  filename        = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

resource "aws_lambda_permission" "s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_trigger.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.trigger_bucket.arn
}

