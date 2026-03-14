variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

variable "topic_name" {
  type        = string
  description = "Name of the SNS topic"
}

variable "email_endpoint" {
  type        = string
  description = "Email address for email subscription"
}

variable "sms_endpoint" {
  type        = string
  description = "Phone number for SMS subscription (e.g. +1234567890)"
}

variable "https_endpoint" {
  type        = string
  description = "HTTPS URL for webhook subscription"
}
