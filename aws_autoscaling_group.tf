resource "aws_launch_configuration" "ghost_server_launch_config" {
  name_prefix                 = "${upper(var.environment)}-GHOST-ASG-"
  image_id                    = data.aws_ami.ubuntu_1804.image_id
  instance_type               = var.ec2_instance_type
  iam_instance_profile        = aws_iam_instance_profile.ghost_profile.name
  security_groups             = [aws_security_group.ghost_sg.id]
  associate_public_ip_address = false
  key_name                    = var.key_name
  user_data                   = data.template_file.user_data.rendered

  root_block_device {
    delete_on_termination = true
    volume_type           = "gp2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ghost_server" {
  name                 = "${upper(var.environment)}-GHOST-ASG"
  launch_configuration = aws_launch_configuration.ghost_server_launch_config.name
  vpc_zone_identifier  = data.aws_subnet_ids.private.ids
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  desired_capacity     = var.asg_desired_capacity

  lifecycle {
    create_before_destroy = true
  }

  tags = [
    {
      key                 = "Name"
      value               = "${upper(var.environment)}-GHOST-EC2-ASG"
      propagate_at_launch = true
    },
  ]
}

