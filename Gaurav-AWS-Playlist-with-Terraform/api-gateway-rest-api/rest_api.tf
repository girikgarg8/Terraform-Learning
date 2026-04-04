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
      aws_api_gateway_resource.students.id,
      aws_api_gateway_resource.student_id.id,
      aws_api_gateway_method.student_get.id,
      aws_api_gateway_integration.students_lambda.id,
      aws_api_gateway_request_validator.full.id,
      aws_api_gateway_model.user_body.id,
      aws_api_gateway_resource.validate.id,
      aws_api_gateway_method.validate_post.id,
      aws_api_gateway_integration.validate_mock.id,
      aws_api_gateway_method_response.validate_200.id,
      aws_api_gateway_integration_response.validate_200.id,
      aws_api_gateway_resource.forward.id,
      aws_api_gateway_method.forward_get.id,
      aws_api_gateway_integration.forward_http.id,
      aws_api_gateway_method_response.forward_200.id,
      aws_api_gateway_integration_response.forward_200.id,
      aws_api_gateway_resource.forward_lambda.id,
      aws_api_gateway_method.forward_lambda_post.id,
      aws_api_gateway_integration.forward_lambda.id,
      aws_api_gateway_method_response.forward_lambda_200.id,
      aws_api_gateway_integration_response.forward_lambda_200.id,
      aws_api_gateway_resource.secure.id,
      aws_api_gateway_method.secure_get.id,
      aws_api_gateway_integration.secure_mock.id,
      aws_api_gateway_method_response.secure_200.id,
      aws_api_gateway_integration_response.secure_200.id,
      aws_api_gateway_resource.keyed.id,
      aws_api_gateway_method.keyed_get.id,
      aws_api_gateway_integration.keyed_mock.id,
      aws_api_gateway_method_response.keyed_200.id,
      aws_api_gateway_integration_response.keyed_200.id,
      aws_api_gateway_authorizer.custom.id,
      aws_api_gateway_resource.auth_demo.id,
      aws_api_gateway_method.auth_demo_get.id,
      aws_api_gateway_integration.auth_demo_lambda.id,
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
