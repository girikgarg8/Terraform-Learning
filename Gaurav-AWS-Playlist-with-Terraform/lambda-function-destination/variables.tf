variable "region" {
  type        = string
  description = "AWS region where the Lambda and SNS topic live"
  default     = "ap-south-1"
}

variable "sns_topic_name" {
  type        = string
  description = "Name of the existing SNS topic (not ARN)"
  default     = "mysampletopic"
}
