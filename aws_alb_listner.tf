resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.ghost.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  depends_on = [
    aws_alb.ghost,
    aws_alb_target_group.http
  ]
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
  certificate_arn = module.cert_ghost_alb.arn
}