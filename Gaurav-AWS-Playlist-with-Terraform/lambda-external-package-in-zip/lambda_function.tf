resource "aws_lambda_function" "with_requests_zip" {
  function_name   = "requests-in-zip"
  role            = aws_iam_role.lambda.arn
  handler         = "lambda_function.lambda_handler"
  runtime         = "python3.12"
  timeout         = 15
  filename        = "${path.module}/requests_in_zip.zip"
  source_code_hash = filebase64sha256("${path.module}/requests_in_zip.zip")
}