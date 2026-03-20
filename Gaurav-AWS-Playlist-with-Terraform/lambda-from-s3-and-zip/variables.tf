variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

variable "s3_bucket_name" {
  type        = string
  description = "Globally unique name for the S3 bucket that stores the Lambda deployment package"
  default     = "ggarg1-testing-girikgarg-lambda-code"
}