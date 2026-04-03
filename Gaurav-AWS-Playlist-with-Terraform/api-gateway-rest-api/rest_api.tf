resource "aws_api_gateway_rest_api" "main" {
  name = "playlist-rest"
}

resource "aws_api_gateway_deployment" "dev" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  triggers = {
    redeploy = sha1(jsonencode([
      aws_api_gateway_resource.mock.id,
      aws_api_gateway_method.mock_get.id,
      aws_api_gateway_integration.mock.id,
      aws_api_gateway_method_response.mock_200.id,
      aws_api_gateway_integration_response.mock_200.id,
      aws_api_gateway_resource.google.id,
      aws_api_gateway_method.google_get.id,
      aws_api_gateway_integration.google_http.id,
      aws_api_gateway_method_response.google_200.id,
      aws_api_gateway_integration_response.google_200.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "dev" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  deployment_id = aws_api_gateway_deployment.dev.id
  stage_name    = "dev"
}
