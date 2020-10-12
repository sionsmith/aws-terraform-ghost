resource "aws_alb_target_group" "http" {
  // target group name limited to 32 characters and only alpha + num + hypens
  name     = "${upper(var.environment)}-GHOST-ALB-TG-HTTP"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.prod.id

  health_check {
    path                = var.alb_health_check_path
    port                = var.alb_health_check_port
    protocol            = var.alb_health_check_protocol
    timeout             = var.alb_health_check_timeout
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = var.alb_health_check_matcher
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = var.alb_sticky_session_duration
    enabled         = var.alb_sticky_session
  }

  lifecycle {
    ignore_changes = [lambda_multi_value_headers_enabled]
  }

  tags = merge(
    var.common_tags,
    {
      "Name" = "${upper(var.environment)}-GHOST-ALB-TG-HTTP"
    },
  )

  // based on https://github.com/hashicorp/terraform/issues/12634
  depends_on = [aws_alb.ghost]
}
