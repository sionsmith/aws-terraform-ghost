resource "aws_alb_listener" "http" {
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.http.arn
  }

  load_balancer_arn = aws_alb.ghost.arn
  port              = 80
}

resource "aws_alb_listener" "https" {
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.http.arn
  }

  load_balancer_arn = aws_alb.ghost.arn
  port              = 443

  protocol        = "HTTPS"
  ssl_policy      = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
}