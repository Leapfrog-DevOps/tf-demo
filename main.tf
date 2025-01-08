## Calling the VPC module
module "vpc" {
  source             = "./modules/vpc"
  name               = "vpc-${var.stage}"
  availability_zones = ["us-east-1a", "us-east-1b"]
}

## Calling the ALB module
module "alb" {
  source                        = "./modules/alb"
  alb_name                      = "alb-prod"
  alb_sg_name                   = "alb-sg-prod"
  aws_acm_certificate_arn       = aws_acm_certificate.cert.arn
  domain_name                   = var.domain_name # Replace with your domain name
  health_check_path             = "/health"
  lb_target_group_name          = "ec2-tg-prod"
  protocol                      = "HTTP"
  public_subnets                = module.vpc.public_subnets
  ssl_policy                    = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  target_group_port             = 80
  target_type                   = "instance"
  target_id                     = module.ec2.ec2_id
  vpc_id                        = module.vpc.vpc_id
  enable_deletion_protection    = false
  stage                         = var.stage
}

## Calling the WAF module
module "waf_prod" {
  source          = "./modules/waf"
  waf_name        = "waf-ddos-protection-${var.stage}"
  waf_description = "WAF for DDOS protection for ${var.stage} environment"
  waf_scope       = "REGIONAL"
  waf_rules = [
    {
      name                      = "AWS-AWSManagedRulesAmazonIpReputationList"
      priority                  = 1
      type                      = "managed_rule_group"
      managed_rule_group_name   = "AWSManagedRulesAmazonIpReputationList"
      managed_rule_group_vendor = "AWS"
      override_action           = "none"
    },
    {
      name                      = "AWS-AWSManagedRulesCommonRuleSet"
      priority                  = 2
      type                      = "managed_rule_group"
      managed_rule_group_name   = "AWSManagedRulesCommonRuleSet"
      managed_rule_group_vendor = "AWS"
      override_action           = "none"
    },
    {
      name                      = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      priority                  = 3
      type                      = "managed_rule_group"
      managed_rule_group_name   = "AWSManagedRulesKnownBadInputsRuleSet"
      managed_rule_group_vendor = "AWS"
      override_action           = "none"
    },
    {
      name                      = "AWS-AWSManagedRulesSQLiRuleSet"
      priority                  = 4
      type                      = "managed_rule_group"
      managed_rule_group_name   = "AWSManagedRulesSQLiRuleSet"
      managed_rule_group_vendor = "AWS"
      override_action           = "none"
    },
    {
      name                      = "AWS-AWSManagedRulesLinuxRuleSet"
      priority                  = 5
      type                      = "managed_rule_group"
      managed_rule_group_name   = "AWSManagedRulesLinuxRuleSet"
      managed_rule_group_vendor = "AWS"
      override_action           = "none"
    },
    {
      name                      = "AWS-AWSManagedRulesAdminProtectionRuleSet"
      priority                  = 6
      type                      = "managed_rule_group"
      managed_rule_group_name   = "AWSManagedRulesAdminProtectionRuleSet"
      managed_rule_group_vendor = "AWS"
      override_action           = "none"
    },
    {
      name          = "geo-location-blocking"
      priority      = 7
      type          = "geo_match"
      country_codes = ["US"]
      action        = "block"
    },
    {
      name       = "rate-limiting"
      priority   = 8
      type       = "rate_based"
      rate_limit = 500
      action     = "block"
    }
  ]
  alb_arn = module.alb.alb_arn

}
