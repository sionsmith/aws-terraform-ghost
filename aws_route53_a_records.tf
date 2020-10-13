# Route53 Public Records
resource "aws_route53_record" "www_record" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = var.domain
  type    = "A"

  alias {
    evaluate_target_health = false
    name                   = aws_alb.ghost.dns_name
    zone_id                = aws_alb.ghost.zone_id
  }
}