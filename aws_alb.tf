resource "aws_alb" "ghost" {
  name                       = "${upper(var.environment)}-GHOST-PUB-UI-ALB"
  subnets                    = data.aws_subnet_ids.public.ids
  internal                   = false
  enable_deletion_protection = var.alb_deletion_protection
  security_groups            = [aws_security_group.ghost_alb.id]
  idle_timeout               = var.alb_idle_timeout

  tags = merge(
    var.common_tags,
    {
      "Name" = "${upper(var.environment)}-GHOST-PUB-UI-ALB"
    },
  )
}

