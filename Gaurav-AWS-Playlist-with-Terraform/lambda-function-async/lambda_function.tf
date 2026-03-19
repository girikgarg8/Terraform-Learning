resource "aws_lambda_function" "async_error" {
  function_name   = "async-error-demo"
  role            = aws_iam_role.lambda.arn
  handler         = "index.lambda_handler"
  runtime         = "python3.12"
  filename        = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  dead_letter_config {
    target_arn = aws_sns_topic.failure.arn
  }
}

resource "aws_lambda_function_event_invoke_config" "async_error" {
  function_name         = aws_lambda_function.async_error.function_name
  maximum_retry_attempts = 2
  destination_config {
    on_failure {
      destination = aws_sns_topic.failure.arn
    }
  }
}
