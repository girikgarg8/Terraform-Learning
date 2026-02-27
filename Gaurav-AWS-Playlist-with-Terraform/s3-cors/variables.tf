variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-south-1"
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name to apply CORS policy to"
}


variable "access_key" {
  type = string
  description = "Access key for terraform user"
}

variable "secret_key" {
  type = string
  description = "Secret key for terraform user"
}
