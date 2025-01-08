## Create ACM Certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = "example.com" # Replace with your domain name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
  tags = merge({ Name = "${var.name}-acm-${var.stage}" }, var.tags)
}
