resource "aws_route53_record" "ec2_record" {
  zone_id = aws_route53_zone.main.zone_id
  name = "ec2.girikgarg.xyz"
  type = "A"
  ttl = 300
  records = [aws_instance.web_server.public_ip]
}