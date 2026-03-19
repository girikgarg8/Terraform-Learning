resource "aws_s3_bucket_notification" "lambda" {
  bucket = data.aws_s3_bucket.trigger_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_trigger.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.s3]
}