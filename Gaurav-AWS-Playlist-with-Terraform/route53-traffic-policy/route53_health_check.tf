resource "aws_route53_health_check" "web" {
  ip_address = aws_instance.web.public_ip
  port = 80
  type = "HTTP"
  resource_path = "/"
  failure_threshold = 3
  request_interval = 30
  tags = {
    Name = "traffic-policy-web-primary"
  }
}