variable "asg_min_size" {
  default = 1
}

variable "asg_max_size" {
  default = 1
}

variable "asg_desired_capacity" {
  default = 1
}

variable "alb_deletion_protection" {
  default = false
}

variable "alb_idle_timeout" {
  default = "60"
}

variable "alb_logs_s3_prefix" {
  default = "webserver"
}

variable "alb_logs_s3_enabled" {
  default = true
}

variable "alb_sticky_session" {
  default = false
}

variable "alb_health_check_path" {
  default     = "/"
  description = "Set path for ALB health check"
}

variable "alb_health_check_port" {
  default     = 80
  description = "Set the port for ALB health check"
}

variable "alb_health_check_protocol" {
  default     = "HTTP"
  description = "Set protocol for the ALB health check"
}

variable "alb_health_check_timeout" {
  default     = 10
  description = "Set the timeout for the ALB health check"
}

variable "alb_health_check_matcher" {
  default     = "200-399"
  description = "Set the webserver responses for the ALB health check"
}

variable "alb_sticky_session_duration" {
  default = "86400"
}
variable "ec2_instance_type" {
  type        = string
  description = "Set EC2 instance type for Ghost server"
  default     = "t3a.small"
}

variable "environment" {
  type = string
}

variable "key_name" {
  type        = string
  description = "Set the EC2 Key name"
}

variable "common_tags" {
  type = map(string)
}




