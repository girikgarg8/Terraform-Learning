resource "aws_route53_record" "ipbased_aps1" {
  zone_id = aws_route53_zone.main.zone_id
  name = "ipbased.girikgarg.xyz"
  type = "A"
  set_identifier = "APS1"

  cidr_routing_policy {
    collection_id = aws_route53_cidr_collection.ip_based.id
    location_name = aws_route53_cidr_location.aps1.name
  }

  records = [aws_instance.web_aps1.public_ip]

  ttl = 3
}

resource "aws_route53_record" "ipbased_usw2" {
  zone_id = aws_route53_zone.main.zone_id
  name = "ipbased.girikgarg.xyz"
  type = "A"
  set_identifier = "USW2"

  cidr_routing_policy {
    collection_id = aws_route53_cidr_collection.ip_based.id
    location_name = aws_route53_cidr_location.usw2.name
  }

  records = [aws_instance.web_usw2.public_ip]

  ttl = 3
}