variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

variable "sns_topic_name" {
  type        = string
  description = "Name of the SNS topic for Lambda async failure destination"
  default     = "mysampletopic"
}
