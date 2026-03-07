resource "aws_route53_health_check" "aps1" {
  fqdn = "aps1.girikgarg.xyz"
  port = 80
  type = "HTTP"
  resource_path = "/"
  failure_threshold = 3
  request_interval = 30
  measure_latency = true
  tags = {
    Name = "health-aps1"
  }
}

resource "aws_route53_health_check" "usw2" {
  fqdn = "usw2.girikgarg.xyz"
  port = 80
  type = "HTTP"
  resource_path = "/"
  failure_threshold = 3
  request_interval = 30
  measure_latency = true
  tags = {
    Name = "health-usw2"
  }
}

resource "aws_route53_health_check" "parent" {
  type = "CALCULATED"
  child_health_threshold = 1
  child_healthchecks = [aws_route53_health_check.aps1.id,aws_route53_health_check.usw2.id]

  tags = {
    Name = "parent-health-aps1-usw2"
  }
}