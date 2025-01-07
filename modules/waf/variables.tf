variable "waf_name" {
  description = "Name of the WAF Web ACL"
  type        = string
}

variable "waf_description" {
  description = "Description of the WAF Web ACL"
  type        = string
}

variable "waf_scope" {
  description = "Scope of the WAF Web ACL (REGIONAL or CLOUDFRONT)"
  type        = string
}

variable "waf_rules" {
  description = "List of WAF rules"
  type = list(object({
    name                      = string
    priority                  = number
    type                      = string
    managed_rule_group_name   = optional(string)
    managed_rule_group_vendor = optional(string)
    override_action           = optional(string)
    action                    = optional(string)
    rate_limit                = optional(number)
    country_codes             = optional(list(string))
    ip_set_arn                = optional(string)
    rule_action_overrides = optional(list(object({
      name   = string
      action = string
    })))
  }))
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "alb_arn" {
  description = "The ARN of the ALB"
  type        = string
}
