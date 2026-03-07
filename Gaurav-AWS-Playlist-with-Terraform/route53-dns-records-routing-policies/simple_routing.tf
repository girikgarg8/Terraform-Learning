resource "aws_route53_record" "simple" {
  zone_id = aws_route53_zone.main.zone_id
  name = "simple.girikgarg.xyz"
  type = "A"
  ttl = 3
  records = [aws_instance.web_aps1.public_ip]
}