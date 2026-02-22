resource "aws_lb" "nlb" {
  name = "nlb-demo"
  load_balancer_type = "network"
  subnets = data.aws_subnets.default.ids
  security_groups = [aws_security_group.nlb.id]
  tags = {
    Name = "nlb-demo"
  }
}