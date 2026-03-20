resource "aws_lambda_function" "add_two_numbers" {
  function_name = "demo-lambda-sns-success-destination"
  role          = aws_iam_role.lambda.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.12"
  timeout       = 10

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  depends_on = [aws_iam_role_policy.sns_publish_destination]
}

resource "aws_lambda_function_event_invoke_config" "success_dest" {
  function_name = aws_lambda_function.add_two_numbers.function_name

  destination_config {
    on_success {
      destination = data.aws_sns_topic.mysampletopic.arn
    }
  }

  depends_on = [aws_lambda_function.add_two_numbers]
}
