resource "aws_wafv2_web_acl" "main" {
  name        = var.waf_name
  description = var.waf_description
  scope       = var.waf_scope

  default_action {
    allow {}
  }

  dynamic "rule" {
    for_each = var.waf_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      dynamic "override_action" {
        for_each = rule.value.type == "managed_rule_group" ? [1] : []
        content {
          none {}
        }
      }

      dynamic "action" {
        for_each = rule.value.type != "managed_rule_group" ? [1] : []
        content {
          dynamic "block" {
            for_each = rule.value.action == "block" ? [1] : []
            content {}
          }
          dynamic "allow" {
            for_each = rule.value.action == "allow" ? [1] : []
            content {}
          }
        }
      }

      statement {
        dynamic "managed_rule_group_statement" {
          for_each = rule.value.type == "managed_rule_group" ? [1] : []
          content {
            name        = rule.value.managed_rule_group_name
            vendor_name = rule.value.managed_rule_group_vendor

            dynamic "rule_action_override" {
              for_each = rule.value.rule_action_overrides != null ? rule.value.rule_action_overrides : []
              content {
                name = rule_action_override.value.name
                action_to_use {
                  dynamic "block" {
                    for_each = rule_action_override.value.action == "block" ? [1] : []
                    content {}
                  }
                }
              }
            }
          }
        }

        dynamic "rate_based_statement" {
          for_each = rule.value.type == "rate_based" ? [1] : []
          content {
            limit              = rule.value.rate_limit
            aggregate_key_type = "IP"
          }
        }

        dynamic "not_statement" {
          for_each = rule.value.type == "geo_match" ? [1] : []
          content {
            statement {
              geo_match_statement {
                country_codes = rule.value.country_codes
              }
            }
          }
        }

        dynamic "ip_set_reference_statement" {
          for_each = rule.value.type == "ip_set_reference" ? [1] : []
          content {
            arn = rule.value.ip_set_arn
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.name
        sampled_requests_enabled   = true
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = var.waf_name
    sampled_requests_enabled   = true
  }

  tags = var.tags
}

resource "aws_wafv2_web_acl_association" "main" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}

resource "aws_cloudwatch_log_group" "waf_log_group" {
  name              = "/aws/waf/${var.waf_name}"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

resource "aws_wafv2_web_acl_logging_configuration" "main" {
  count                   = var.enable_logging ? 1 : 0
  log_destination_configs = [aws_cloudwatch_log_group.waf_log_group.arn]
  resource_arn            = aws_wafv2_web_acl.main.arn

  dynamic "logging_filter" {
    for_each = var.logging_filter_enabled ? [1] : []
    content {
      default_behavior = var.logging_filter_default_behavior

      dynamic "filter" {
        for_each = var.logging_filters
        content {
          behavior = filter.value.behavior
          condition {
            action_condition {
              action = filter.value.action
            }
          }
          requirement = filter.value.requirement
        }
      }
    }
  }
}
