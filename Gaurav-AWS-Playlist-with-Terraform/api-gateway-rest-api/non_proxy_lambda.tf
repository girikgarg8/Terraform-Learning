data "archive_file" "hello_nonproxy_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/hello"
  output_path = "${path.module}/hello_nonproxy_lambda.zip"
}

# Trust policy so the Lambda service can assume this role.
resource "aws_iam_role" "lambda_basic" {
  name = "playlist-lambda-basic"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attaches AWS managed policy for CloudWatch Logs (Lambda basic execution).
resource "aws_iam_role_policy_attachment" "lambda_basic_logs" {
  role       = aws_iam_role.lambda_basic.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Hello-world Lambda package from archive_file; handler returns statusCode/headers/body for non-proxy mapping.
resource "aws_lambda_function" "hello_nonproxy" {
  function_name    = "playlist-hello-nonproxy"
  role             = aws_iam_role.lambda_basic.arn
  runtime          = "python3.13"
  handler          = "handler.handler"
  filename         = data.archive_file.hello_nonproxy_zip.output_path
  source_code_hash = data.archive_file.hello_nonproxy_zip.output_base64sha256
}

data "archive_file" "transform_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/transform"
  output_path = "${path.module}/transform_lambda.zip"
}

# Echoes VTL-mapped fields (escaped body fragment + query size) for POST /forward-lambda.
resource "aws_lambda_function" "transform_target" {
  function_name    = "playlist-transform-target"
  role             = aws_iam_role.lambda_basic.arn
  runtime          = "python3.13"
  handler          = "handler.handler"
  filename         = data.archive_file.transform_lambda_zip.output_path
  source_code_hash = data.archive_file.transform_lambda_zip.output_base64sha256
}

# Adds the /lambda path segment under the API root.
resource "aws_api_gateway_resource" "lambda_path" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "lambda"
}

# Exposes GET on /lambda with no authorization (public).
resource "aws_api_gateway_method" "lambda_get" {
  rest_api_id     = aws_api_gateway_rest_api.main.id
  resource_id     = aws_api_gateway_resource.lambda_path.id
  http_method     = "GET"
  authorization   = "NONE"
}

# Non-proxy AWS integration: POST invoke of hello_nonproxy with JSON mapping template input.
resource "aws_api_gateway_integration" "lambda_nonproxy" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.lambda_path.id
  http_method             = aws_api_gateway_method.lambda_get.http_method
  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.hello_nonproxy.arn}/invocations"
  passthrough_behavior    = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = "{\"source\":\"apigw\",\"requestId\":\"$context.requestId\"}"
  }
}

# Lets API Gateway invoke the Lambda for this REST API/stage/methods.
resource "aws_lambda_permission" "apigw_hello" {
  statement_id  = "AllowAPIGatewayInvoke"
  action          = "lambda:InvokeFunction"
  function_name   = aws_lambda_function.hello_nonproxy.function_name
  principal       = "apigateway.amazonaws.com"
  source_arn      = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

# Declares that this method may return HTTP 200 to the client.
resource "aws_api_gateway_method_response" "lambda_200" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.lambda_path.id
  http_method   = aws_api_gateway_method.lambda_get.http_method
  status_code   = "200"
}

# Topic 11: reshape Lambda output — client sees wrapped JSON, not raw $r.body alone.
resource "aws_api_gateway_integration_response" "lambda_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.lambda_path.id
  http_method   = aws_api_gateway_method.lambda_get.http_method
  status_code   = aws_api_gateway_method_response.lambda_200.status_code
  depends_on    = [aws_api_gateway_integration.lambda_nonproxy]

  response_templates = {
    "application/json" = <<-EOT
#set($r = $input.path('$'))
{"msg":"wrapped","inner":"$util.escapeJavaScript($r.body)"}
EOT
  }
}

# POST /forward-lambda: VTL maps body + query size into Lambda event (non-proxy).
resource "aws_api_gateway_resource" "forward_lambda" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "forward-lambda"
}

resource "aws_api_gateway_method" "forward_lambda_post" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.forward_lambda.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "forward_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.forward_lambda.id
  http_method             = aws_api_gateway_method.forward_lambda_post.http_method
  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.transform_target.arn}/invocations"
  passthrough_behavior    = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = <<-EOT
{
  "rawBody": "$util.escapeJavaScript($input.body)",
  "size": "$util.escapeJavaScript($input.params('size'))"
}
EOT
  }
}

resource "aws_lambda_permission" "apigw_transform" {
  statement_id  = "AllowAPIGatewayTransformForwardLambda"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.transform_target.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

resource "aws_api_gateway_method_response" "forward_lambda_200" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.forward_lambda.id
  http_method   = aws_api_gateway_method.forward_lambda_post.http_method
  status_code   = "200"
}

resource "aws_api_gateway_integration_response" "forward_lambda_200" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.forward_lambda.id
  http_method   = aws_api_gateway_method.forward_lambda_post.http_method
  status_code   = aws_api_gateway_method_response.forward_lambda_200.status_code
  depends_on    = [aws_api_gateway_integration.forward_lambda]

  response_templates = {
    "application/json" = "#set($r = $input.path('$'))$r.body"
  }
}