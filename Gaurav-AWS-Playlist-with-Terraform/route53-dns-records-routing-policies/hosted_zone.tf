resource "aws_route53_zone" "main" {
  name = "girikgarg.xyz"
  tags = {
    Name = "girikgarg.xyz"
  }
}