resource "aws_lambda_function" "versioned" {
  function_name   = "versioned-demo"
  role            = aws_iam_role.lambda.arn
  handler         = "index.lambda_handler"
  runtime         = "python3.12"
  filename        = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  publish         = true

  environment {
    variables = {
      BUILD_TAG = var.build_tag
    }
  }
}