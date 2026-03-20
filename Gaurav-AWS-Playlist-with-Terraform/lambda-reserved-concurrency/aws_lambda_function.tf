resource "aws_lambda_function" "demo_reserved" {
  function_name    = "demo-reserved-concurrency"
  role             = aws_iam_role.lambda.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.12"
  timeout          = 15
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  # Max concurrent executions for this function
  reserved_concurrent_executions = var.reserved_concurrency
}

resource "aws_lambda_function_url" "demo_reserved" {
  function_name      = aws_lambda_function.demo_reserved.function_name
  authorization_type = "NONE"
}

resource "aws_lambda_permission" "demo_reserved_url" {
  statement_id           = "AllowPublicURLReserved"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.demo_reserved.function_name
  principal              = "*"
  function_url_auth_type = "NONE"
}

resource "aws_lambda_permission" "demo_reserved_invoke" {
  statement_id  = "AllowPublicInvokeReserved"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.demo_reserved.function_name
  principal     = "*"
}