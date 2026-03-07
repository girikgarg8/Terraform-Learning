resource "aws_route53_record" "latency_aps1" {
  zone_id = aws_route53_zone.main.zone_id
  name = "latency.girikgarg.xyz"
  type = "A"
  set_identifier = "aps1"
  records = [aws_instance.web_aps1.public_ip]
  ttl = 3
  latency_routing_policy {
    region = "ap-south-1"
  }
}

resource "aws_route53_record" "latency_usw2" {
  zone_id = aws_route53_zone.main.zone_id
  name = "latency.girikgarg.xyz"
  type = "A"
  set_identifier = "usw2"
  records = [aws_instance.web_usw2.public_ip]
  ttl = 3
  latency_routing_policy {
    region = "us-west-2"
  }
}