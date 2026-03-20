resource "aws_lambda_function" "demo_provisioned" {
  function_name    = "demo-provisioned-concurrency"
  role             = aws_iam_role.lambda.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.12"
  timeout          = 15
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  publish = true

  reserved_concurrent_executions = var.reserved_concurrency > 0 ? var.reserved_concurrency : null
}

resource "aws_lambda_alias" "live" {
  name             = "live"
  function_name    = aws_lambda_function.demo_provisioned.function_name
  function_version = aws_lambda_function.demo_provisioned.version
}

resource "aws_lambda_provisioned_concurrency_config" "live_pc" {
  count = var.provisioned_concurrency > 0 ? 1 : 0

  function_name                     = aws_lambda_function.demo_provisioned.function_name
  qualifier                         = aws_lambda_alias.live.name
  provisioned_concurrent_executions = var.provisioned_concurrency

  depends_on = [aws_lambda_alias.live]
}
