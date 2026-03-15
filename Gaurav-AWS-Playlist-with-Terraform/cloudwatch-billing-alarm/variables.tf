variable "billing_alarm_threshold_usd" {
  type = number
  description = "Estimated charges (USD) above which to trigger the alarm"
  default = 100
}

variable "sns_topic_name" {
  type = string
  description = "SNS topic name in us-east-1 for billing alerts"
  default = "billing-alerts"
}

variable "sns_topic_email" {
  type = string
  description = "Email subscribing to SNS topic"
}