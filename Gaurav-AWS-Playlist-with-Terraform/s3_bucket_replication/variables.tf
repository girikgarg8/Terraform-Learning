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


variable "source_bucket_name" {
  type = string
  description = "Source S3 bucket name"
}

variable "destination_bucket_name" {
  type = string
  description = "Destination S3 bucket name"
}