variable "region" {
  type = string
  description = "AWS region"
  default = "ap-south-1"
}

variable "query_log_bucket_name" {
  type = string
  description = "S3 bucket name for Resolver query logs - (globally unique)"
  default = "route53-default-vpc-query-logs-ggarg1"
}

variable "dns_firewall_rule_group_name" {
  type = string
  default = "default-vpc-firewall"
  description = "Name for DNS Firewall rule group"
}

variable "blocked_domains" {
  type = list(string)
  default = [ "google.com." ]
  description = "Domain list to block (trailing dot for FQDN)"
}