resource "aws_s3_bucket" "www" {
  bucket = "www.static-website-testing-s3-girik-garg"
}

# Redirect all requests from www bucket to the main bucket's website endpoint
resource "aws_s3_bucket_website_configuration" "www" {
  bucket = aws_s3_bucket.www.id

  redirect_all_requests_to {
    host_name = "${aws_s3_bucket.website.id}.s3-website.${var.region}.amazonaws.com"
    protocol  = "http"
  }
}