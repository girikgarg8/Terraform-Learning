# Custom domain for REST API (REGIONAL): ACM certificate must live in the same region as this API Gateway (provider default = var.aws_region), not us-east-1.

resource "aws_acm_certificate" "demo" {
  domain_name       = var.api_gateway_custom_domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "demo_cert" {
  for_each = {
    for dvo in aws_acm_certificate.demo.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.public.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

# Blocks apply: keeps polling ACM until the cert is ISSUED (after Route53 serves the validation CNAMEs); required before API Gateway can attach the cert.
resource "aws_acm_certificate_validation" "demo" {
  certificate_arn         = aws_acm_certificate.demo.arn
  validation_record_fqdns = [for r in aws_route53_record.demo_cert : r.fqdn]
}

resource "aws_api_gateway_domain_name" "demo" {
  domain_name              = var.api_gateway_custom_domain_name
  regional_certificate_arn = aws_acm_certificate_validation.demo.certificate_arn
  security_policy          = "TLS_1_2"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "demo" {
  api_id      = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.dev.stage_name
  domain_name = aws_api_gateway_domain_name.demo.domain_name
}

resource "aws_route53_record" "demo_alias" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = var.api_gateway_custom_domain_name
  type    = "A"
  alias {
    name                   = aws_api_gateway_domain_name.demo.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.demo.regional_zone_id
    evaluate_target_health = false
  }
}

resource "aws_api_gateway_method" "custom_domain_root_get" {
  rest_api_id     = aws_api_gateway_rest_api.main.id
  resource_id     = aws_api_gateway_rest_api.main.root_resource_id
  http_method     = "GET"
  authorization   = "NONE"
}

resource "aws_api_gateway_integration" "custom_domain_root" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_rest_api.main.root_resource_id
  http_method = aws_api_gateway_method.custom_domain_root_get.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\":200}"
  }
}

resource "aws_api_gateway_method_response" "custom_domain_root_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_rest_api.main.root_resource_id
  http_method = aws_api_gateway_method.custom_domain_root_get.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "custom_domain_root_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_rest_api.main.root_resource_id
  http_method = aws_api_gateway_method.custom_domain_root_get.http_method
  status_code = aws_api_gateway_method_response.custom_domain_root_200.status_code
  depends_on  = [aws_api_gateway_integration.custom_domain_root]

  response_templates = {
    "application/json" = "{\"message\":\"hello girik\"}"
  }
}