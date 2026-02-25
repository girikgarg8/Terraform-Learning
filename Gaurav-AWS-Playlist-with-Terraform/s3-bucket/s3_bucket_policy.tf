data "aws_iam_policy_document" "bucket_public_get" {
  statement {
    sid = "PublicReadGetObject"
    effect = "Allow"
    principals {
        type = "*"
        identifiers = ["*"]
    }
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.main.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.bucket_public_get.json

  depends_on = [ aws_s3_bucket_public_access_block.main ]
}