# Domain list:  domains to block
resource "aws_route53_resolver_firewall_domain_list" "blocked" {
  name = "block-google"
  domains = var.blocked_domains
}

# Firewall rule group (container for rules)
resource "aws_route53_resolver_firewall_rule_group" "main" {
    name = var.dns_firewall_rule_group_name
    tags = {
      Name = var.dns_firewall_rule_group_name
    }
}

# Block rule: block queries for domains in the list
resource "aws_route53_resolver_firewall_rule" "block_google" {
  name = "block-google"
  action = "BLOCK"
  block_response = "NODATA"
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.main.id
  firewall_domain_list_id = aws_route53_resolver_firewall_domain_list.blocked.id
  priority = 100
}

# Associate rule group with default VPC (DNS queries from this VPC go through firewall)
# Priority must be 101-9900 (100 is reserved by AWS)
resource "aws_route53_resolver_firewall_rule_group_association" "default_vpc" {
  name                   = "default-vpc-dns-default"
  firewall_rule_group_id = aws_route53_resolver_firewall_rule_group.main.id
  vpc_id                 = data.aws_vpc.default.id
  priority               = 200
}