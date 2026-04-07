variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "root_domain" {
  type        = string
  description = "Hosted zone name (eg: girikgarg.xyz) - SES and Route53"
  default     = "girikgarg.xyz"
}

variable "user_pool_name" {
  type        = string
  default     = "ggarg1-demo-user-pool"
  description = "Cognito user pool name."
}

variable "domain_mode" {
  type        = string
  description = "managed = *.auth.<region>.amazoncognito.com | custom = own hostname + ACM (us-east-1)"
  validation {
    condition     = contains(["managed", "custom"], var.domain_mode)
    error_message = "domain_mode must be \"managed\" or \"custom\"."
  }
}


variable "cognito_domain_prefix" {
  type        = string
  default     = ""
  description = "Required when domain_mode=managed. Globally unique."
}

variable "custom_domain_host" {
  type        = string
  default     = ""
  description = "Required when domain_mode=custom, e.g. cognitodemo.girikgarg.xyz"
}

variable "ses_domain_identity_arn" {
  type        = string
  default     = ""
  description = "Verified SES domain identity ARN. Leave empty to use identity/<root_domain> in current account/region."
  validation {
    condition = (
      var.ses_domain_identity_arn == "" ||
      can(regex("^arn:aws:ses:[a-z0-9-]+:[0-9]{12}:identity/", var.ses_domain_identity_arn))
    )
    error_message = "ses_domain_identity_arn must be empty (auto from root_domain + account) or a valid SES identity ARN."
  }
}

variable "callback_urls" {
  type    = list(string)
  default = ["https://example.com/callback"]
}

variable "logout_urls" {
  type    = list(string)
  default = ["https://example.com/logout"]
}

variable "demo_user_email" {
  type    = string
  default = "demo.user@example.com"
}

variable "demo_user_password" {
  type      = string
  sensitive = true
}

variable "demo_user_name" {
  type    = string
  default = "Demo user"
}

variable "demo_user_gender" {
  type        = string
  default     = null
  description = "Optional custom:gender; set after first apply to demo 'late' attribute, or set from start"
}
