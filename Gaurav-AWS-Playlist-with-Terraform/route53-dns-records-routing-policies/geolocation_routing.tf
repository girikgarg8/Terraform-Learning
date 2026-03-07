resource "aws_route53_record" "geo_india" {
  zone_id = aws_route53_zone.main.zone_id
  name = "geolocation.girikgarg.xyz"
  type = "A"
  set_identifier = "India"
  geolocation_routing_policy {
    country = "IN"
  }
  records = [aws_instance.web_aps1.public_ip]
  ttl = 3
}

resource "aws_route53_record" "geo_us" {
  zone_id = aws_route53_zone.main.zone_id
  name = "geolocation.girikgarg.xyz"
  type = "A"
  set_identifier = "US"
  geolocation_routing_policy {
    country = "US"
  }
  records = [aws_instance.web_usw2.public_ip]
  ttl = 3
}

resource "aws_route53_record" "geo_default" {
  zone_id = aws_route53_zone.main.zone_id
  name = "geolocation.girikgarg.xyz"
  type = "A"
  set_identifier = "Default"
  geolocation_routing_policy {
    continent = "NA"
  }
  records = [aws_instance.web_usw2.public_ip]
  ttl = 3
}