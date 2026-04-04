variable "aws_region" {
  type = string
  default = "ap-south-1"
}

variable "backend_url" {
  type        = string
  description = "Full URL for GET /forward (e.g. https://webhook.site/<uuid> or https://httpbin.org/get)."
  validation {
    condition     = can(regex("^https?://", var.backend_url))
    error_message = "backend_url must start with http:// or https://."
  }
}

variable "api_gateway_custom_domain_name" {
  type        = string
  default     = "demo.girikgarg.xyz"
}

variable "canary_demo_step" {
  type    = number
  default = 1
  description = <<-EOT
    Canary MOCK demo (canary_stage.tf). Run terraform from the api-gateway-rest-api directory.
    1 — Stable MOCK body + stable deployment snapshot only.
    2 — Canary MOCK body + canary deployment + stage canary-demo (50 percent traffic to canary). Run 1 before 2 on a new API.
    3 — Restore live MOCK to stable; snapshots and stage unchanged.
  EOT
  validation {
    condition     = contains([1, 2, 3], var.canary_demo_step)
    error_message = "canary_demo_step must be 1, 2, or 3."
  }
}