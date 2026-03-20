variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

variable "reserved_concurrency" {
  type        = number
  description = "Reserved concurrent executions for demo Lambda. Use -1 to disable reservation."
  default     = -1
}
