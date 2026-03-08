resource "aws_route53_traffic_policy" "demo" {
  name    = "demo-traffic-policy"
  comment = "Primary EC2 + failover for ${var.domain}"
  document = templatefile("${path.module}/traffic_policy_document.json.tpl", {
    ec2_ip         = aws_instance.web.public_ip
    health_check_id = aws_route53_health_check.web.id
  })
}

# Apply the traffic policy to the hosted zone (creates the DNS record, e.g. www.<domain>)
resource "aws_route53_traffic_policy_instance" "www" {
  name                   = "www.${var.domain}"
  traffic_policy_id      = aws_route53_traffic_policy.demo.id
  traffic_policy_version = aws_route53_traffic_policy.demo.version
  hosted_zone_id         = aws_route53_zone.main.zone_id
  ttl                    = 60
}