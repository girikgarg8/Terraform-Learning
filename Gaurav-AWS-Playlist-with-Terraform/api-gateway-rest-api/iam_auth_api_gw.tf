# IAM user used in Postman (SigV4) to call GET /secure — not for API Gateway console admin.
resource "aws_iam_user" "apigw_tester" {
  name = "playlist-apigw-tester"
}

# execute-api:Invoke is required to call the deployed API; apigateway:* admin policies do not cover SigV4 invoke.
resource "aws_iam_user_policy" "apigw_tester_invoke" {
  name = "invoke-playlist-rest-api"
  user = aws_iam_user.apigw_tester.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["execute-api:Invoke"]
      Resource = "${aws_api_gateway_rest_api.main.execution_arn}/*"
    }]
  })
}

resource "aws_iam_access_key" "apigw_tester" {
  user = aws_iam_user.apigw_tester.name
}

# GET /secure under API root (parent must be root, not self-reference).
resource "aws_api_gateway_resource" "secure" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "secure"
}

# SigV4 required; integration runs only after IAM authorizes the caller.
resource "aws_api_gateway_method" "secure_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.secure.id
  http_method   = "GET"
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "secure_mock" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.secure.id
  http_method = aws_api_gateway_method.secure_get.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\":200}"
  }
}

resource "aws_api_gateway_method_response" "secure_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.secure.id
  http_method = aws_api_gateway_method.secure_get.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "secure_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.secure.id
  http_method = aws_api_gateway_method.secure_get.http_method
  status_code = aws_api_gateway_method_response.secure_200.status_code
  depends_on  = [aws_api_gateway_integration.secure_mock]

  response_templates = {
    "application/json" = "{\"message\":\"secure ok\"}"
  }
}

output "tester_access_key_id" {
  value       = aws_iam_access_key.apigw_tester.id
  sensitive   = true
  description = "Access key ID for SigV4 (Postman AWS Signature)."
}

output "tester_secret_access_key" {
  value       = aws_iam_access_key.apigw_tester.secret
  sensitive   = true
  description = "Secret access key for SigV4; rotate if exposed."
}
