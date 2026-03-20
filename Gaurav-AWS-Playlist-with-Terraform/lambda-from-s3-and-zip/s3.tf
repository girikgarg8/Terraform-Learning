resource "aws_s3_bucket" "lambda_code" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_code.id
  key    = "hello.zip"
  source = data.archive_file.from_zip.output_path
  etag   = data.archive_file.from_zip.output_md5
}
