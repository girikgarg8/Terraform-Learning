# Adds the /google path segment under the API root.
resource "aws_api_gateway_resource" "google" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "google"
}

# Exposes GET on /google with no authorization (public).
resource "aws_api_gateway_method" "google_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.google.id
  http_method   = "GET"
  authorization = "NONE"
}

# HTTP integration: forwards the method to https://www.google.com (GET).
resource "aws_api_gateway_integration" "google_http" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.google.id
  http_method             = aws_api_gateway_method.google_get.http_method
  type                    = "HTTP"
  integration_http_method = "GET"
  uri                     = "https://www.google.com"
}

# Declares that this method may return HTTP 200 to the client.
resource "aws_api_gateway_method_response" "google_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.google.id
  http_method = aws_api_gateway_method.google_get.http_method
  status_code = "200"
}

# Maps backend 200 responses through to the client (pass-through; depends on integration existing first).
resource "aws_api_gateway_integration_response" "google_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.google.id
  http_method = aws_api_gateway_method.google_get.http_method
  status_code = aws_api_gateway_method_response.google_200.status_code
  depends_on  = [aws_api_gateway_integration.google_http]
}
