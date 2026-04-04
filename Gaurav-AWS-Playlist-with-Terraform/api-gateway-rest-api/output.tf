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

output "canary_demo_get_url" {
  value = local.canary_demo_stage_enabled ? "https://${aws_api_gateway_rest_api.main.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.canary_demo[0].stage_name}/canary-mock" : null
  description = "GET this URL after canary_demo_step >= 2. Roughly half the responses show backend stable vs canary (MOCK). See canary_demo_step variable."
}