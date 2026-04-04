# GET /forward → HTTP GET to var.backend_url; maps query ?size= → backend ?count= and header x-isTest → X-Forwarded-Custom.
resource "aws_api_gateway_resource" "forward" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "forward"
}

resource "aws_api_gateway_method" "forward_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.forward.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.querystring.size"     = false
    "method.request.header.x-isTest"    = false
  }
}

# HTTP integration: outbound GET; query/header transforms via request_parameters (no body on GET).
resource "aws_api_gateway_integration" "forward_http" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.forward.id
  http_method             = aws_api_gateway_method.forward_get.http_method
  type                    = "HTTP"
  integration_http_method = "GET"
  uri                     = var.backend_url
  request_parameters = {
    "integration.request.querystring.count"           = "method.request.querystring.size"
    "integration.request.header.X-Forwarded-Custom"   = "method.request.header.x-isTest"
  }
}

resource "aws_api_gateway_method_response" "forward_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.forward.id
  http_method = aws_api_gateway_method.forward_get.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "forward_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.forward.id
  http_method = aws_api_gateway_method.forward_get.http_method
  status_code = aws_api_gateway_method_response.forward_200.status_code
  depends_on  = [aws_api_gateway_integration.forward_http]
}
