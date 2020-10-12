resource "aws_security_group" "ghost_alb" {
  description = "Ghost - Managed by Terraform"
  name        = "${upper(var.environment)}-GHOST-PUB-ALB-SG"
  vpc_id      = data.aws_vpc.prod.id

  tags = merge(
    var.common_tags,
    {
      "Name" = "${upper(var.environment)}-GHOST-PUB-ALB-SG"
    },
  )
}

resource "aws_security_group_rule" "ghost_alb_ingress_80" {
  from_port         = 80
  protocol          = "TCP"
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ghost_alb.id
}

resource "aws_security_group_rule" "ghost_alb_ingress_443" {
  from_port         = 443
  protocol          = "TCP"
  to_port           = 443
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ghost_alb.id
}

resource "aws_security_group_rule" "ghost_alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ghost_alb.id
}

