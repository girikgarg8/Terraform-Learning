data "archive_file" "students_lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/students"
  output_path = "${path.module}/students_lambda.zip"
}

# Students API: path /students/{id}; echoes id plus ?page=&size= from query string (proxy event).
resource "aws_lambda_function" "students" {
  function_name    = "playlist-students"
  role             = aws_iam_role.lambda_basic.arn
  runtime          = "python3.13"
  handler          = "handler.handler"
  filename         = data.archive_file.students_lambda_zip.output_path
  source_code_hash = data.archive_file.students_lambda_zip.output_base64sha256
}

# Path prefix /students.
resource "aws_api_gateway_resource" "students" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "students"
}

# Path parameter {id} -> /students/{id}.
resource "aws_api_gateway_resource" "student_id" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_resource.students.id
  path_part   = "{id}"
}

# GET /students/{id}; id required; page/size/x-isTest optional (method params for docs/cache/validation).
resource "aws_api_gateway_method" "student_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.student_id.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.id"               = true
    "method.request.querystring.page"      = false
    "method.request.querystring.size"      = false
    "method.request.header.x-isTest"       = false
  }
}

# Lambda proxy: full request (including x-isTest) is in the event; no header mapping needed here.
resource "aws_api_gateway_integration" "students_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.student_id.id
  http_method             = aws_api_gateway_method.student_get.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_function.students.invoke_arn
}

# Allows API Gateway to invoke students Lambda.
resource "aws_lambda_permission" "students_apigw" {
  statement_id  = "AllowAPIGatewayStudents"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.students.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

# Validates JSON body + required query/header params before integration runs.
resource "aws_api_gateway_request_validator" "full" {
  name                        = "playlist-full"
  rest_api_id                 = aws_api_gateway_rest_api.main.id
  validate_request_body       = true
  validate_request_parameters = true
}

# JSON Schema for POST body: required string userId (application/json).
resource "aws_api_gateway_model" "user_body" {
  rest_api_id  = aws_api_gateway_rest_api.main.id
  name         = "UserBody"
  content_type = "application/json"
  schema = jsonencode({
    type     = "object"
    required = ["userId"]
    properties = {
      userId = { type = "string" }
    }
  })
}

resource "aws_api_gateway_resource" "validate" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "validate"
}

# POST /validate: body must match UserBody; page, size, x-isTest required at method level.
resource "aws_api_gateway_method" "validate_post" {
  rest_api_id          = aws_api_gateway_rest_api.main.id
  resource_id          = aws_api_gateway_resource.validate.id
  http_method          = "POST"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.full.id
  request_models = {
    "application/json" = aws_api_gateway_model.user_body.name
  }
  request_parameters = {
    "method.request.querystring.page"     = true
    "method.request.querystring.size"     = true
    "method.request.header.x-isTest"      = true
  }
}

# MOCK backend so we only exercise validation + mapping (no Lambda).
resource "aws_api_gateway_integration" "validate_mock" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.validate.id
  http_method = aws_api_gateway_method.validate_post.http_method
  type        = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\":200}"
  }
}

resource "aws_api_gateway_method_response" "validate_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.validate.id
  http_method = aws_api_gateway_method.validate_post.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "validate_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.validate.id
  http_method = aws_api_gateway_method.validate_post.http_method
  status_code = aws_api_gateway_method_response.validate_200.status_code
  depends_on  = [aws_api_gateway_integration.validate_mock]

  response_templates = {
    "application/json" = "{\"message\":\"validation passed\"}"
  }
}