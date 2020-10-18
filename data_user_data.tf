data "template_file" "user_data" {
  template = file("${path.module}/scripts/user_data.sh")

  vars = {
      domain = var.domain
      ses_email = var.smtp_email_address
      ses_username = var.smtp_ses_username
      ses_password = var.smtp_ses_password
      ghost_resources_bucket = local.ghost_resources_bucket_name
  }
}

