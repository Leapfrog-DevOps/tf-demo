## Calling the VPC module
module "vpc" {
  source             = "./modules/vpc"
  name               = "vpc-prod"
  availability_zones = ["us-east-1a", "us-east-1b"]
}

## Calling the ALB module
module "alb" {
  source                     = "./modules/alb"
  alb_name                   = "alb-prod"
  alb_sg_name                = "alb-sg-prod"
  aws_acm_certificate_arn    = aws_acm_certificate.cert.arn
  domain_name                = var.domain_name # Replace with your domain name
  health_check_path          = "/"
  lb_target_group_name       = "ec2-tg-prod"
  protocol                   = "HTTP"
  public_subnets             = module.vpc.public_subnets
  ssl_policy                 = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  target_group_port          = 80
  target_type                = "instance"
  target_id                  = module.ec2.ec2_id
  vpc_id                     = module.vpc.vpc_id
  enable_deletion_protection = false
  stage                      = var.stage
}

## Calling the WAF module
module "waf_prod" {
  source                          = "./modules/waf"
  waf_name                        = "waf-ddos-protection-${var.stage}"
  waf_description                 = "WAF for DDOS protection for ${var.stage} environment"
  waf_scope                       = "REGIONAL"
  enable_logging                  = true
  log_retention_days              = 60
  logging_filter_default_behavior = "KEEP"
  logging_filter_enabled          = true
  logging_filters = [
    {
      action      = "BLOCK"
      behavior    = "KEEP"
      requirement = "MEETS_ALL"
    }
  ]
  waf_rules = [
    {
      name       = "rate-limiting"
      priority   = 1
      type       = "rate_based"
      rate_limit = 500
      action     = "block"
    },
    {
      name                      = "AWS-AWSManagedRulesAmazonIpReputationList"
      priority                  = 2
      type                      = "managed_rule_group"
      managed_rule_group_name   = "AWSManagedRulesAmazonIpReputationList"
      managed_rule_group_vendor = "AWS"
      override_action           = "none"
    },
    {
      name                      = "AWS-AWSManagedRulesCommonRuleSet"
      priority                  = 3
      type                      = "managed_rule_group"
      managed_rule_group_name   = "AWSManagedRulesCommonRuleSet"
      managed_rule_group_vendor = "AWS"
      override_action           = "none"
    },
    {
      name                      = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      priority                  = 4
      type                      = "managed_rule_group"
      managed_rule_group_name   = "AWSManagedRulesKnownBadInputsRuleSet"
      managed_rule_group_vendor = "AWS"
      override_action           = "none"
    },
    {
      name                      = "AWS-AWSManagedRulesSQLiRuleSet"
      priority                  = 5
      type                      = "managed_rule_group"
      managed_rule_group_name   = "AWSManagedRulesSQLiRuleSet"
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
      country_codes = ["US"] ## Replace with your country codes to allow access; e.g., ["US", "NP"]. not_statement has been used on the waf module to allow access to the specified country codes.
      action        = "block"
    }
  ]
  alb_arn = module.alb.alb_arn

}


## Calling the Shield module
## Note: Consider the cost of Shield Advanced before enabling it.
module "shield" {
  source       = "./modules/shield"
  resource_arn = module.alb.alb_arn
  stage        = var.stage
}
