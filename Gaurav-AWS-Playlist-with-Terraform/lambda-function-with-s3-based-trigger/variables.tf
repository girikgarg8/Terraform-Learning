variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

variable "s3_trigger_bucket_name" {
  type        = string
  description = "Name of the existing S3 bucket that triggers the Lambda"
  default     = "new-temp-bucket-girik-ggarg1"
}
