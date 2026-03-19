resource "aws_iam_role" "lambda" {
  name = "lambda-s3-trigger-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Allow Lambda to read from the trigger bucket (for event context / optional GetObject)
resource "aws_iam_role_policy" "lambda_s3_read" {
  name   = "lambda-s3-read"
  role   = aws_iam_role.lambda.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:ListBucket"
      ]
      Resource = [
        data.aws_s3_bucket.trigger_bucket.arn,
        "${data.aws_s3_bucket.trigger_bucket.arn}/*"
      ]
    }]
  })
}
