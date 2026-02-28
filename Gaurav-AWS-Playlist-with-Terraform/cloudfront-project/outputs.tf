output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.app.domain_name
  description = "CloudFront distribution domain (e.g. xxx.cloudfront.net)"
}

output "cloudfront_url" {
  value       = "https://${aws_cloudfront_distribution.app.domain_name}"
  description = "Base URL for the distribution"
}

output "customheader_url" {
  value       = "https://${aws_cloudfront_distribution.app.domain_name}/customheader"
  description = "URL that requires req_from header from CloudFront"
}

output "origin_ec2_public_dns" {
  value       = aws_instance.app.public_dns
  description = "EC2 origin public DNS (direct access for comparison)"
}

output "origin_direct_url" {
  value       = "http://${aws_instance.app.public_dns}"
  description = "Direct origin URL (no CloudFront)"
}
