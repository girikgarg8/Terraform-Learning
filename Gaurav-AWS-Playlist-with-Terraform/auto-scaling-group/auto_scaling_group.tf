resource "aws_autoscaling_group" "web" {
  name = "web-asg"
  min_size = 1
  max_size = 4
  desired_capacity = 1
  vpc_zone_identifier = data.aws_subnets.default.ids
  load_balancers = [var.clb_name] # attach new instances to this clb
  health_check_type = "ELB"
  health_check_grace_period = 120

  launch_template {
    id = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key = "Name"
    value = "web-asg"
    propagate_at_launch = true
  }
}