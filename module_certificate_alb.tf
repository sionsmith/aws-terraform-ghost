module "cert_ghost_alb" {
  source = "git::ssh://git@github.com/osodevops/aws-terraform-module-acm-certificate"

  domain_name                       = var.domain
  subject_alternative_names         = ["www.${var.domain}"]
  hosted_zone_id                    = data.aws_route53_zone.zone.id
  validation_record_ttl             = "60"
  allow_validation_record_overwrite = true
}