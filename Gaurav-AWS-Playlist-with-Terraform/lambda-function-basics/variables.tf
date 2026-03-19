variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

variable "lambda_env_name" {
  type        = string
  description = "Environment variable value for Lambda"
  default     = "Lambda Demo"
}
