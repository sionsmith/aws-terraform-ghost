data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}