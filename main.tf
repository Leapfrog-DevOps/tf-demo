module "vpc" {
  source             = "./modules/vpc"
  name               = "vpc-${var.environment}"
  availability_zones = ["us-east-1a", "us-east-1b"]
}


module "alb" {
  source                        = "./modules/alb"
  alb_name                      = "alb-prod"
  alb_sg_name                   = "alb-sg-prod"
  aws_acm_certificate_arn       = "arn:aws:acm:us-east-1:1234567890:certificate/12345678-1234-1234-1234-123456789012" ## example
  domain_name                   = "example.com"
  health_check_path             = "/health"
  lb_target_group_name          = "ecs-tg-prod"
  protocol                      = "HTTP"
  public_subnets                = module.vpc.public_subnets
  ssl_policy                    = "ELBSecurityPolicy-FS-1-1-2019-08"
  target_group_port             = 80
  target_type                   = "ip"
  vpc_id                        = module.vpc.vpc_id
  s3_bucket_alb_logs            = ""
  bucket_prefix_access_logs     = ""
  bucket_prefix_connection_logs = ""
  enabled                       = false
  enable_deletion_protection    = false
  environment                   = var.environment
}

module "waf_prod" {
  source          = "./modules/waf"
  waf_name        = "waf-ddos-protection-${var.environment}"
  waf_description = "WAF for DDOS protection for ${var.environment} environment"
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
      name                      = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      priority                  = 5
      type                      = "managed_rule_group"
      managed_rule_group_name   = "AWSManagedRulesKnownBadInputsRuleSet"
      managed_rule_group_vendor = "AWS"
      override_action           = "none"
    },
    {
      name                      = "AWS-AWSManagedRulesLinuxRuleSet"
      priority                  = 6
      type                      = "managed_rule_group"
      managed_rule_group_name   = "AWSManagedRulesLinuxRuleSet"
      managed_rule_group_vendor = "AWS"
      override_action           = "none"
    },
    {
      name                      = "AWS-AWSManagedRulesAdminProtectionRuleSet"
      priority                  = 7
      type                      = "managed_rule_group"
      managed_rule_group_name   = "AWSManagedRulesAdminProtectionRuleSet"
      managed_rule_group_vendor = "AWS"
      override_action           = "none"
    },
    {
      name          = "geo-location-blocking"
      priority      = 8
      type          = "geo_match"
      country_codes = ["US"]
      action        = "block"
    },
    {
      name       = "rate-limiting"
      priority   = 9
      type       = "rate_based"
      rate_limit = 500
      action     = "block"
    }
  ]
  alb_arn = module.alb_prod.alb_arn

}
