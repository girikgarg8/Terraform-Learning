resource "aws_route53_record" "weighted_aps1" {
  zone_id = aws_route53_zone.main.zone_id
  name = "weighted.girikgarg.xyz"
  type = "A"
  set_identifier = "aps1"
  weighted_routing_policy {
    weight = 70
  }
  records = [aws_instance.web_aps1.public_ip]
  ttl = 3
}

resource "aws_route53_record" "weighted_usw2" {
  zone_id = aws_route53_zone.main.zone_id
  name = "weighted.girikgarg.xyz"
  type = "A"
  set_identifier = "usw2"
  weighted_routing_policy {
    weight = 30
  }
  records = [aws_instance.web_usw2.public_ip]
  ttl = 3
}