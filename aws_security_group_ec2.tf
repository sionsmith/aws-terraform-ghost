resource "aws_security_group" "ghost_sg" {
  description = "Security group that allows all traffic from alb to Ghost server"
  name        = "${upper(var.environment)}-WEBSERVER-INT-SG"
  vpc_id      = data.aws_vpc.prod.id

  tags = {
    Name = "${upper(var.environment)}-WEBSERVER-INT-SG"
  }
}

resource "aws_security_group_rule" "ghost_sg_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.ghost_sg.id
  source_security_group_id = aws_security_group.ghost_alb.id
}

resource "aws_security_group_rule" "webserver-sg-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ghost_sg.id
}

