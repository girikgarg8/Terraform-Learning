variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

variable "project_name" {
  type        = string
  description = "Prefix for resource names"
  default     = "lambda-rds-connecity"
}
