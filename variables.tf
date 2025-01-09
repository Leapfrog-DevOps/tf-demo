variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  type        = string
  default     = "prod"
}

variable "name" {
  description = "Name  (e.g. `app` or `cluster`)"
  type        = string
}

variable "tls_private_key_algorithm" {
  type    = string
  default = "RSA"
}

variable "tls_private_key_rsa_bits" {
  type    = number
  default = 4096
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to all resources"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the ACM certificate"
  default     = "example.com" # Replace with your domain name
}
