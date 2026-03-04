resource "aws_elb" "web_clb" {
  name = "web-clb"
  availability_zones = data.aws_availability_zones.available.names

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    interval = 30
    target = "HTTP:80/"
    timeout = 5
    unhealthy_threshold = 2
  }

  instances = [aws_instance.web_server.id]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags = {
    Name = "web-clb"
  }
}

data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_route53_record" "root_alias" {
  zone_id = aws_route53_zone.main.zone_id
  name = "girikgarg.xyz"
  type = "A"

  alias {
    name = aws_elb.web_clb.dns_name
    zone_id = aws_elb.web_clb.zone_id
    evaluate_target_health = true
  }
}