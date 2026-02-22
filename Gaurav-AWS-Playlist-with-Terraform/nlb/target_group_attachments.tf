resource "aws_lb_target_group_attachment" "nlb" {
  count = length(aws_instance.web)
  target_group_arn = aws_lb_target_group.nlb_tg.arn
  target_id = aws_instance.web[count.index].id
  port = 80
}