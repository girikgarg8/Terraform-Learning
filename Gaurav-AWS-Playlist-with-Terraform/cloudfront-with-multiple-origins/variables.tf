variable "region" {
  type = string
  description = "AWS region"
}

variable "access_key" {
  type = string
  description = "Access key for terraform user"
}

variable "secret_key" {
  type = string
  description = "Secret key for terraform user"
}

variable "s3_bucket_domain" {
  type = string
  description = "S3 origin: bucket website endpoint"
}

variable "ec2_origin_domain" {
  type = string
  description = "EC2 origin: public DNS (e.g. ec2-x-x-x-x.region.compute.amazonaws.com) "
}