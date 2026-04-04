data "archive_file" "authorizer_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/authorizer"
  output_path = "${path.module}/authorizer_lambda.zip"
}

data "archive_file" "auth_demo_backend_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/auth_demo_backend"
  output_path = "${path.module}/auth_demo_backend_lambda.zip"
}

# TOKEN authorizer: compares myAuthHeader value to "valid"; passes userid in context when allowed.
resource "aws_lambda_function" "authorizer" {
  function_name    = "playlist-api-authorizer"
  role             = aws_iam_role.lambda_basic.arn
  runtime          = "python3.13"
  handler          = "handler.handler"
  filename         = data.archive_file.authorizer_lambda_zip.output_path
  source_code_hash = data.archive_file.authorizer_lambda_zip.output_base64sha256
}

resource "aws_lambda_permission" "authorizer_apigw" {
  statement_id  = "AllowAuthorizerInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.authorizer.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

# identity_source = header myAuthHeader; its value becomes event["authorizationToken"].
resource "aws_api_gateway_authorizer" "custom" {
  name                             = "playlist-custom"
  rest_api_id                      = aws_api_gateway_rest_api.main.id
  authorizer_uri                   = aws_lambda_function.authorizer.invoke_arn
  type                             = "TOKEN"
  identity_source                  = "method.request.header.myAuthHeader"
  authorizer_result_ttl_in_seconds = 0
}

resource "aws_lambda_function" "auth_demo_backend" {
  function_name    = "playlist-auth-demo-backend"
  role             = aws_iam_role.lambda_basic.arn
  runtime          = "python3.13"
  handler          = "handler.handler"
  filename         = data.archive_file.auth_demo_backend_zip.output_path
  source_code_hash = data.archive_file.auth_demo_backend_zip.output_base64sha256
}

resource "aws_api_gateway_resource" "auth_demo" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "auth-demo"
}

resource "aws_api_gateway_method" "auth_demo_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.auth_demo.id
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.custom.id
}

resource "aws_api_gateway_integration" "auth_demo_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.auth_demo.id
  http_method             = aws_api_gateway_method.auth_demo_get.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.auth_demo_backend.invoke_arn
}

resource "aws_lambda_permission" "auth_demo_backend_apigw" {
  statement_id  = "AllowAPIGatewayAuthDemoBackend"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth_demo_backend.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}
