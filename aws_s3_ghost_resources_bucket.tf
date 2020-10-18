module "ghost_resources_bucket" {
  source                  = "git::ssh://git@github.com/osodevops/aws-terraform-module-s3.git"
  s3_bucket_name          = local.ghost_resources_bucket_name
  s3_bucket_force_destroy = false
  s3_bucket_policy        = ""
  common_tags             = var.common_tags

  # Bucket public access
  restrict_public_buckets = true
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true

  versioning = {
    enabled = false
  }
}