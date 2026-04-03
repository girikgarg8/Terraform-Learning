# Adds the /mock path segment under the API root.
resource "aws_api_gateway_resource" "mock" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id = aws_api_gateway_rest_api.main.root_resource_id
  path_part = "mock"
}

# Exposes GET on /mock with no authorization (public).
resource "aws_api_gateway_method" "mock_get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.mock.id
  http_method = "GET"
  authorization = "NONE"
}

# MOCK integration: maps matching requests to integration status 200 via request template (no real backend).
resource "aws_api_gateway_integration" "mock" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.mock.id
  http_method = aws_api_gateway_method.mock_get.http_method
  type = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\":200}"
  }
}

# Declares that this method may return HTTP 200 to the client.
resource "aws_api_gateway_method_response" "mock_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.mock.id
  http_method = aws_api_gateway_method.mock_get.http_method
  status_code = "200"
}

# For integration status 200, shapes the actual response body returned to the caller.
resource "aws_api_gateway_integration_response" "mock_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.mock.id
  http_method = aws_api_gateway_method.mock_get.http_method
  status_code = aws_api_gateway_method_response.mock_200.status_code
  depends_on = [ aws_api_gateway_integration.mock ]

  response_templates = {
    "application/json" = "{\"message\":\"hello girik\"}"
  }

}
