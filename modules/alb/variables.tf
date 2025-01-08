variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "alb_name" {
  description = "The name of the ALB"
  type        = string
}

variable "public_subnets" {
  description = "The public subnets to use for the ALB"
  type        = list(string)
}

variable "protocol" {
  description = "The protocol to use for the target group"
  type        = string
}

variable "lb_target_group_name" {
  description = "The name of the target group"
  type        = string
}

variable "target_group_port" {
  description = "The port to use for the target group"
  type        = number
}

variable "target_type" {
  description = "The type of target to use for the target group"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "health_check_path" {
  description = "The path to use for the health check"
  type        = string
}


variable "domain_name" {
  type        = string
  description = "The domain name to use for the ALB"
}

variable "ssl_policy" {
  type        = string
  description = "The SSL policy to use for the ALB"
}

variable "aws_acm_certificate_arn" {
  type        = string
  description = "The ARN of the ACM certificate to use for the ALB"
}

variable "alb_sg_name" {
  type        = string
  description = "The name of the security group for the ALB"
}

variable "s3_bucket_alb_logs" {
  type        = string
  description = "The name of the S3 bucket to use for ALB logs"
}

variable "bucket_prefix_access_logs" {
  type        = string
  description = "The prefix to use for ALB access logs"
}

variable "bucket_prefix_connection_logs" {
  type        = string
  description = "The prefix to use for ALB connection logs"
}

variable "enabled" {
  type        = bool
  description = "Whether to enable ALB logs"
}

variable "enable_deletion_protection" {
  type        = bool
  description = "Whether to enable deletion protection for the ALB"
}

variable "stage" {
  type        = string
  description = "The environment to use for the ALB"
}
