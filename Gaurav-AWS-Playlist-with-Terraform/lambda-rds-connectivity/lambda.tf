resource "aws_lambda_function" "rds_connectivity" {
  function_name = "${var.project_name}-probe"
  role          = aws_iam_role.lambda.arn
  handler       = "index.lambda_handler"
  runtime       = "python3.12"
  timeout       = 30

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      DB_HOST = aws_db_instance.main.address
      DB_PORT = "3306"
    }
  }

  vpc_config {
    subnet_ids         = [aws_subnet.private_a.id]
    security_group_ids = [aws_security_group.lambda.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_vpc,
    aws_nat_gateway.nat,
  ]
}

# Easy connectivity test (lab only — open URL)
resource "aws_lambda_function_url" "probe" {
  function_name      = aws_lambda_function.rds_connectivity.function_name
  authorization_type = "NONE"
}

# Must exist after the Function URL; otherwise the resource policy can be incomplete → 403 Forbidden
resource "aws_lambda_permission" "url_public" {
  statement_id           = "AllowPublicURL"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.rds_connectivity.function_name
  principal              = "*"
  function_url_auth_type = "NONE"

  depends_on = [aws_lambda_function_url.probe]
}

# Some accounts / clients expect this statement as well for unauthenticated URL invokes
resource "aws_lambda_permission" "invoke_public" {
  statement_id  = "AllowPublicInvokeFunction"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rds_connectivity.function_name
  principal     = "*"

  depends_on = [aws_lambda_function_url.probe]
}
