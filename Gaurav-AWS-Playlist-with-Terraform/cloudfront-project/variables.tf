variable "region" {
  type        = string
  description = "AWS region for resources"
  default = "ap-south-1"
}

variable "key_name" {
  type = string
  description = "SSH key for EC2 instance"
  default = "girik-ssh-key"
}

variable "access_key" {
  type = string
  description = "Access key for terraform user"  
}

variable "secret_key" {
  type = string
  description = "Secret key for terraform user"  
}

variable "project_name" {
  type        = string
  default     = "cloudfront-demo"
  description = "Prefix for resource names"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 instance type for the app server"
}

variable "docker_image" {
  type        = string
  default     = "coolgourav147/cloud-front-nodejs"
  description = "Docker image to run (app listens on 3000)"
}

variable "origin_custom_header_name" {
  type        = string
  default     = "req_from"
  description = "Header name CloudFront sends to origin (for /customheader API)"
}

variable "origin_custom_header_value" {
  type        = string
  default     = "cloudfront_head"
  description = "Header value CloudFront sends to origin"
}

variable "cache_min_ttl" {
  type        = number
  default     = 1
  description = "Minimum TTL for cache policy (seconds)"
}

variable "cache_max_ttl" {
  type        = number
  default     = 86400
  description = "Maximum TTL for cache policy (seconds)"
}

variable "cache_default_ttl" {
  type        = number
  default     = 86400
  description = "Default TTL for cache policy (seconds)"
}

variable "price_class" {
  type        = string
  default     = "PriceClass_100"
  description = "CloudFront price class: PriceClass_100 (US, Canada, Europe), PriceClass_200 (+ Asia), PriceClass_All"
}
