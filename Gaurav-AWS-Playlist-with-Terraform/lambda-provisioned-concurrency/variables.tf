variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

# Set >0 only if your account quota allows (otherwise apply fails with UnreservedConcurrentExecution).
variable "reserved_concurrency" {
  type        = number
  description = "Reserved concurrency for this function; omit when 0 (recommended when account limit is 10)."
  default     = 0
}

variable "provisioned_concurrency" {
  type        = number
  description = "Provisioned concurrency on alias \"live\". Default 0 — AWS requires enough account concurrency that unreserved pool stays ≥10; with a 10-unit account limit, use 0 or request a Service Quotas increase."
  default     = 0
}
