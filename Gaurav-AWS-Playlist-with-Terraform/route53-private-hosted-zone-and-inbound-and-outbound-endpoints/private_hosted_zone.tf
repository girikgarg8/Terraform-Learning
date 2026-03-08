resource "aws_route53_zone" "private" {
  name = var.private_zone_name
  vpc {
    vpc_id = aws_vpc.test.id
  }
  tags = {
    Name = var.private_zone_name
  }
}

resource "aws_route53_record" "test" {
  zone_id = aws_route53_zone.private.zone_id
  name = "test.${var.private_zone_name}"
  type = "A"
  ttl = 60
  records = ["8.8.8.8"]
}