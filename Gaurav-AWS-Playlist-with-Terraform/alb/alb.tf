resource "aws_lb" "main" {
    name = "blue-green-alb"
    load_balancer_type = "application"
    security_groups = [aws_security_group.alb.id]
    subnets = data.aws_subnets.default.ids
    tags = {
        Name = "blue-green-alb"
    }
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.main.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "fixed-response"
      fixed_response {
        content_type = "text/plain"
        message_body = "No match"
        status_code = "404"
      }
    }
}

resource "aws_lb_listener_rule" "blue" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }

  condition {
    path_pattern {
      values = ["/blue", "/blue/*"]
    }
  }
}

resource "aws_lb_listener_rule" "green" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green.arn
  }

  condition {
    path_pattern {
      values = ["/green", "/green/*"]
    }
  }
}