resource "aws_lambda_function" "demo" {
  function_name    = "vpc-private-with-nat-demo"
  role             = aws_iam_role.lambda.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.12"
  timeout          = 30
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  vpc_config {
    subnet_ids         = [aws_subnet.private.id]
    security_group_ids = [aws_security_group.lambda.id]
  }
}

resource "aws_lambda_function_url" "demo" {
  function_name      = aws_lambda_function.demo.function_name
  authorization_type = "NONE"
}

resource "aws_lambda_permission" "demo_url" {
  statement_id           = "AllowPublicURLPrivate"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.demo.function_name
  principal              = "*"
  function_url_auth_type = "NONE"
}

resource "aws_lambda_permission" "demo_invoke" {
  statement_id  = "AllowPublicInvokePrivate"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.demo.function_name
  principal     = "*"
}
