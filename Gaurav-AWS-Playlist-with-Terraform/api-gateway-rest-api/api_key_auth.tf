# API key value (send as header x-api-key or query); paired with usage plan below.
resource "aws_api_gateway_api_key" "playlist" {
  name = "playlist-key"
}

# Links dev stage to throttle/quota; key must be associated to this plan to count.
resource "aws_api_gateway_usage_plan" "playlist" {
  name = "playlist-plan"
  api_stages {
    api_id = aws_api_gateway_rest_api.main.id
    stage  = aws_api_gateway_stage.dev.stage_name
  }

  throttle_settings {
    burst_limit = 10
    rate_limit  = 5
  }

  quota_settings {
    limit  = 1000
    period = "DAY"
  }
}

resource "aws_api_gateway_usage_plan_key" "playlist" {
  key_id        = aws_api_gateway_api_key.playlist.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.playlist.id
}

resource "aws_api_gateway_resource" "keyed" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "keyed"
}

# Requires valid key associated with a usage plan that includes this stage.
resource "aws_api_gateway_method" "keyed_get" {
  rest_api_id      = aws_api_gateway_rest_api.main.id
  resource_id      = aws_api_gateway_resource.keyed.id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = true
}

resource "aws_api_gateway_integration" "keyed_mock" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.keyed.id
  http_method = aws_api_gateway_method.keyed_get.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\":200}"
  }
}

resource "aws_api_gateway_method_response" "keyed_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.keyed.id
  http_method = aws_api_gateway_method.keyed_get.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "keyed_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.keyed.id
  http_method = aws_api_gateway_method.keyed_get.http_method
  status_code = aws_api_gateway_method_response.keyed_200.status_code
  depends_on  = [aws_api_gateway_integration.keyed_mock]

  response_templates = {
    "application/json" = "{\"message\":\"keyed ok\"}"
  }
}

output "api_key_value" {
  value       = aws_api_gateway_api_key.playlist.value
  sensitive   = true
  description = "Pass as x-api-key (or configure in Postman API Key auth)."
}
