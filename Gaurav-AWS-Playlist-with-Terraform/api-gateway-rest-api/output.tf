output "rest_invoke_url_dev" {
  value = "https://${aws_api_gateway_rest_api.main.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.dev.stage_name}"
}

output "rest_invoke_url_prod" {
  value = "https://${aws_api_gateway_rest_api.main.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.prod.stage_name}"
}

output "versioned_get_urls" {
  value = {
    dev  = "${aws_api_gateway_rest_api.main.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.dev.stage_name}/versioned"
    prod = "${aws_api_gateway_rest_api.main.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.prod.stage_name}/versioned"
  }
  description = "Use https:// in front. dev → test alias (50/50 v1/v2); prod → prod alias (uncomment routing_config in lambda_versioning.tf for 50/50 on prod)."
}