resource "aws_lambda_function" "add_two_numbers" {
  function_name = "add-two-numbers"
  role = aws_iam_role.lambda.arn
  handler = "index.lambda_handler"
  runtime = "python3.12"
  timeout = 30

  environment {
    variables = {
      name = var.lambda_env_name
    }
  }

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

resource "aws_lambda_function_url" "add_two" {
  function_name = aws_lambda_function.add_two_numbers.function_name
  authorization_type = "NONE"
}

# Required for public Function URL (auth type NONE)
resource "aws_lambda_permission" "add_two_url" {
  statement_id           = "AllowPublicURL"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.add_two_numbers.function_name
  principal              = "*"
  function_url_auth_type = "NONE"
}

# Some configurations also require InvokeFunction for URL invocation
resource "aws_lambda_permission" "add_two_invoke" {
  statement_id  = "AllowPublicInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.add_two_numbers.function_name
  principal     = "*"
}

