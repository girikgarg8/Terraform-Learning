resource "aws_route53_record" "multivalue_aps1" {
  zone_id = aws_route53_zone.main.zone_id
  name = "multivalue.girikgarg.xyz"
  type = "A"
  set_identifier = "aps1"
  records = [aws_instance.web_aps1.public_ip]
  ttl = 3
  multivalue_answer_routing_policy = true
}

resource "aws_route53_record" "multivalue_usw2" {
  zone_id = aws_route53_zone.main.zone_id
  name = "multivalue.girikgarg.xyz"
  type = "A"
  set_identifier = "usw2"
  records = [aws_instance.web_usw2.public_ip]
  ttl = 3
  multivalue_answer_routing_policy = true
}