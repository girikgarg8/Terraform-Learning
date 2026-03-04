resource "aws_route53_record" "txt_record" {
  zone_id = aws_route53_zone.main.zone_id
  name = "test.girikgarg.xyz"
  type = "TXT"
  ttl = 300
  records = ["v=test123 this is a random test value"]
}