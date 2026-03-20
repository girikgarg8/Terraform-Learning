resource "aws_lambda_function" "from_zip" {
  function_name   = "from-zip"
  role            = aws_iam_role.lambda.arn
  handler         = "hello.lambda_handler"
  runtime         = "python3.12"
  filename        = data.archive_file.from_zip.output_path
  source_code_hash = data.archive_file.from_zip.output_base64sha256
}

resource "aws_lambda_function" "from_s3" {
  function_name   = "from-s3"
  role            = aws_iam_role.lambda.arn
  handler         = "hello.lambda_handler"
  runtime         = "python3.12"
  s3_bucket       = aws_s3_bucket.lambda_code.id
  s3_key          = aws_s3_object.lambda_zip.key
  source_code_hash = data.archive_file.from_zip.output_base64sha256
}