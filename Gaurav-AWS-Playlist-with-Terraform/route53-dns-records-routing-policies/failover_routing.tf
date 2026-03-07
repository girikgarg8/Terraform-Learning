resource "aws_route53_record" "failover_primary" {
  zone_id = aws_route53_zone.main.zone_id
  name = "failover.girikgarg.xyz"
  type = "A"
  set_identifier = "Primary"
  failover_routing_policy {
    type = "PRIMARY"
  }
  records = [aws_instance.web_aps1.public_ip]
  ttl = 3
  health_check_id = aws_route53_health_check.aps1.id
}

resource "aws_route53_record" "failover_secondary" {
  zone_id = aws_route53_zone.main.zone_id
  name = "failover.girikgarg.xyz"
  type = "A"
  set_identifier = "Secondary"
  failover_routing_policy {
    type = "SECONDARY"
  }
  records = [aws_instance.web_usw2.public_ip]
  ttl = 3
  health_check_id = aws_route53_health_check.usw2.id
}