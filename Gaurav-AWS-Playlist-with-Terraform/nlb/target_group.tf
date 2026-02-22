resource "aws_lb_target_group" "nlb_tg" {
  name = "nlb-tcp-tg"
  port = 80
  protocol = "TCP"
  vpc_id = data.aws_vpc.default.id
  target_type = "instance"

  health_check {
    protocol = "TCP"
    port = "80"
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 10
  }
}