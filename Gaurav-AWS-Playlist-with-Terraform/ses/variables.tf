variable "region" {
  type = string
  description = "AWS region"
  default = "ap-south-1"
}

variable "sender_email" {
  type = string
}

variable "recipient_email" {
  type = string
}