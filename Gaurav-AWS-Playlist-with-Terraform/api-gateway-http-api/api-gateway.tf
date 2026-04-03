resource "aws_apigatewayv2_api" "http_google" {
    name = "http-google"
    protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "google" {
  api_id = aws_apigatewayv2_api.http_google.id
  integration_type = "HTTP_PROXY"
  integration_method = "GET"
  integration_uri = "https://www.google.com"
}

resource "aws_apigatewayv2_route" "google" {
  api_id = aws_apigatewayv2_api.http_google.id
  route_key = "GET /google"
  target = "integrations/${aws_apigatewayv2_integration.google.id}"
}

resource "aws_apigatewayv2_stage" "http_default" {
  api_id = aws_apigatewayv2_api.http_google.id
  name = "$default"
  auto_deploy = true
}
