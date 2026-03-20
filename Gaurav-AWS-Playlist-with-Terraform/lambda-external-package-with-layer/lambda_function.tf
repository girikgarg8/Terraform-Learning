resource "aws_lambda_function" "with_requests_layer" {
  function_name   = "requests-layer-demo"
  role            = aws_iam_role.lambda.arn
  handler         = "index.lambda_handler"
  runtime         = "python3.12"
  timeout         = 15
  filename        = data.archive_file.function_zip.output_path
  source_code_hash = data.archive_file.function_zip.output_base64sha256
  layers          = [aws_lambda_layer_version.requests.arn]
}
