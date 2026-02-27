variable "access_key" {
  type = string
  description = "Access key for terraform user"
}

variable "secret_key" {
  type = string
  description = "Secret key for terraform user"
}

variable "region" {
  type = string
  description = "AWS region"
}

variable "bucket_name" {
  type = string
  description = "S3 bucket name"
}