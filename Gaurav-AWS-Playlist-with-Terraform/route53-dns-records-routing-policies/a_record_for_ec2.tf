resource "aws_route53_record" "aps1_simple" {
  zone_id = aws_route53_zone.main.zone_id
  name = "aps1.girikgarg.xyz"
  type = "A"
  ttl = 3
  records = [aws_instance.web_aps1.public_ip]
}

resource "aws_route53_record" "usw2_simple" {
  zone_id = aws_route53_zone.main.zone_id
  name = "usw2.girikgarg.xyz"
  type = "A"
  ttl = 3
  records = [aws_instance.web_usw2.public_ip]
}