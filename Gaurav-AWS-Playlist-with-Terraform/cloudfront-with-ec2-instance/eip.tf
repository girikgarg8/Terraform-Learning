resource "aws_eip" "nginx" { # so CloudFront origin hostname is stable
  instance = aws_instance.nginx.id
  domain = "vpc"
}