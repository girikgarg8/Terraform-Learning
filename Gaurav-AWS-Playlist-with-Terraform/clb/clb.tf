resource "aws_elb" "nginx" {
    name = "nginx-clb"
    subnets = data.aws_subnets.default.ids
    security_groups = [aws_security_group.clb.id]
    instances = aws_instance.nginx[*].id

    listener {
      instance_port = 80
      instance_protocol = "http"
      lb_port = 80
      lb_protocol = "http"
    }


    health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 3
      target = "HTTP:80/"
      interval = 30
    }

    tags = {
        Name = "nginx-clb"
    }
}