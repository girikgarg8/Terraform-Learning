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
      aws_api_gateway_resource.lambda_path.id,
      aws_api_gateway_method.lambda_get.id,
      aws_api_gateway_integration.lambda_nonproxy.id,
      aws_api_gateway_method_response.lambda_200.id,
      aws_api_gateway_integration_response.lambda_200.id,
      aws_api_gateway_resource.ddb.id,
      aws_api_gateway_method.ddb_post.id,
      aws_api_gateway_integration.ddb_query.id,
      aws_api_gateway_method_response.ddb_200.id,
      aws_api_gateway_integration_response.ddb_200.id,
      # Integration template edits do not change resource ids; hash file so deploy picks up VTL changes.
      filemd5("${path.module}/dynamodb_backend.tf"),
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
