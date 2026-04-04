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
