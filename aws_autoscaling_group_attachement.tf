resource "aws_autoscaling_attachment" "http" {
  autoscaling_group_name = aws_autoscaling_group.ghost_server.id
  alb_target_group_arn   = aws_alb_target_group.http.arn
}
