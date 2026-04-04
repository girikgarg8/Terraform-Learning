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