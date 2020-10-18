resource "null_resource" "copy_themes_to_s3" {
  provisioner "local-exec" {
    command = "aws s3 cp ${path.module}/themes/. s3://${local.ghost_resources_bucket_name}/themes/ --recursive"
  }
}