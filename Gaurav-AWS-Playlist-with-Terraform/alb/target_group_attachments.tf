resource "aws_lb_target_group_attachment" "blue" {
  count = length(aws_instance.blue)
  target_group_arn = aws_lb_target_group.blue.arn
  target_id = aws_instance.blue[count.index].id
  port = 80
}

resource "aws_lb_target_group_attachment" "green" {
  count = length(aws_instance.green)
  target_group_arn = aws_lb_target_group.green.arn
  target_id = aws_instance.green[count.index].id
  port = 80
}