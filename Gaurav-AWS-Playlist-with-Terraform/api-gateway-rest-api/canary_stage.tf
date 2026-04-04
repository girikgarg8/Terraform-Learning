# Stage-level canary with MOCK integration on GET /canary-mock.
# API Gateway snapshots deployments: stable and canary must be captured at different
# times. Set variable canary_demo_step in variables.tf (see description there).

locals {
  # Live integration template: only step 2 uses the canary body so the canary deployment snapshot differs from stable.
  canary_demo_live_is_canary = var.canary_demo_step == 2
  canary_demo_stage_enabled  = var.canary_demo_step >= 2
  canary_demo_mock_body = local.canary_demo_live_is_canary ? jsonencode({
    backend = "canary"
    demo    = "api-gateway-stage-canary"
    }) : jsonencode({
    backend = "stable"
    demo    = "api-gateway-stage-canary"
  })
}

resource "aws_api_gateway_resource" "canary_demo" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "canary-mock"
}

resource "aws_api_gateway_method" "canary_demo_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.canary_demo.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "canary_demo" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.canary_demo.id
  http_method = aws_api_gateway_method.canary_demo_get.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\":200}"
  }
}

resource "aws_api_gateway_method_response" "canary_demo_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.canary_demo.id
  http_method = aws_api_gateway_method.canary_demo_get.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "canary_demo_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.canary_demo.id
  http_method = aws_api_gateway_method.canary_demo_get.http_method
  status_code = aws_api_gateway_method_response.canary_demo_200.status_code
  depends_on  = [aws_api_gateway_integration.canary_demo]

  response_templates = {
    "application/json" = local.canary_demo_mock_body
  }
}

# Fixed trigger: recreate only when bumping this string (new stable baseline).
resource "aws_api_gateway_deployment" "canary_demo_stable" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  triggers = {
    redeploy = "canary-mock-stable-v1"
  }
  depends_on = [
    aws_api_gateway_integration_response.canary_demo_200,
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_deployment" "canary_demo_canary" {
  count       = local.canary_demo_stage_enabled ? 1 : 0
  rest_api_id = aws_api_gateway_rest_api.main.id
  triggers = {
    redeploy = "canary-mock-canary-v1"
  }
  depends_on = [
    aws_api_gateway_integration_response.canary_demo_200,
  ]
  lifecycle {
    create_before_destroy = true
  }
}

# Primary deployment = stable snapshot; canary_settings.deployment_id = canary snapshot. 50% to canary per AWS.
resource "aws_api_gateway_stage" "canary_demo" {
  count         = local.canary_demo_stage_enabled ? 1 : 0
  rest_api_id   = aws_api_gateway_rest_api.main.id
  deployment_id = aws_api_gateway_deployment.canary_demo_stable.id
  stage_name    = "canary-demo"

  canary_settings {
    deployment_id            = aws_api_gateway_deployment.canary_demo_canary[0].id
    percent_traffic          = 50.0
    use_stage_cache          = false
    stage_variable_overrides = {}
  }
}
