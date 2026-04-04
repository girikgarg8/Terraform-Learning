# Slice 14 / Topic 15: versions, aliases, stages, weighted routing.
#
# Lambda is declared with v2 zip ($LATEST matches Terraform). null_resource then:
#   upload v1 zip → publish-version (numeric v1, "hello from v1") → upload v2 zip → publish-version (numeric v2, "hello from v2").
# So v1 and v2 always exist before aliases that reference version "2" in routing_config.
#
# Aliases: prod = 100% v1; test = 50/50 v1+v2. Uncomment prod routing_config for prod 50/50 (Lambda only; API GW URI unchanged).
#
# Requires AWS CLI (same account/region as Terraform). Applies use bash (-c).

data "archive_file" "versioned_v1_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/versioned_v1"
  output_path = "${path.module}/versioned_v1_lambda.zip"
}

data "archive_file" "versioned_v2_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/versioned_v2"
  output_path = "${path.module}/versioned_v2_lambda.zip"
}

resource "aws_lambda_function" "versioned" {
  function_name    = "rest-versioned"
  role             = aws_iam_role.lambda_basic.arn
  runtime          = "python3.13"
  handler          = "handler.handler"
  filename         = data.archive_file.versioned_v2_zip.output_path
  source_code_hash = data.archive_file.versioned_v2_zip.output_base64sha256
  publish          = false
}

resource "null_resource" "versioned_publish_v1_v2" {
  depends_on = [aws_lambda_function.versioned]

  triggers = {
    function_name = aws_lambda_function.versioned.function_name
    v1_hash       = data.archive_file.versioned_v1_zip.output_base64sha256
    v2_hash       = data.archive_file.versioned_v2_zip.output_base64sha256
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
set -euo pipefail
FN='${aws_lambda_function.versioned.function_name}'
V1='${data.archive_file.versioned_v1_zip.output_path}'
V2='${data.archive_file.versioned_v2_zip.output_path}'
export AWS_DEFAULT_REGION='${var.aws_region}'
aws lambda update-function-code --function-name "$FN" --zip-file "fileb://$V1"
aws lambda wait function-updated --function-name "$FN"
aws lambda publish-version --function-name "$FN" --description 'hello-v1'
aws lambda update-function-code --function-name "$FN" --zip-file "fileb://$V2"
aws lambda wait function-updated --function-name "$FN"
aws lambda publish-version --function-name "$FN" --description 'hello-v2'
EOT
  }
}

resource "aws_lambda_alias" "test" {
  name             = "test"
  function_name    = aws_lambda_function.versioned.function_name
  function_version = "1"

  routing_config {
    additional_version_weights = {
      "2" = 0.5
    }
  }

  depends_on = [null_resource.versioned_publish_v1_v2]
}

resource "aws_lambda_alias" "prod" {
  name             = "prod"
  function_name    = aws_lambda_function.versioned.function_name
  function_version = "1"

  # Phase 2: uncomment for 50/50 on prod (then terraform apply — no API Gateway redeploy).
  routing_config {
    additional_version_weights = {
      "2" = 0.5
    }
  }

  depends_on = [null_resource.versioned_publish_v1_v2]
}

resource "aws_api_gateway_resource" "versioned" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "versioned"
}

resource "aws_api_gateway_method" "versioned_get" {
  rest_api_id     = aws_api_gateway_rest_api.main.id
  resource_id     = aws_api_gateway_resource.versioned.id
  http_method     = "GET"
  authorization   = "NONE"
}

resource "aws_api_gateway_integration" "versioned_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.main.id
  resource_id             = aws_api_gateway_resource.versioned.id
  http_method             = aws_api_gateway_method.versioned_get.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  # $${...} escapes Terraform interpolation so API Gateway receives ${stageVariables.lambdaAlias}.
  uri = join("", [
    "arn:aws:apigateway:",
    var.aws_region,
    ":lambda:path/2015-03-31/functions/",
    aws_lambda_function.versioned.arn,
    ":$${stageVariables.lambdaAlias}/invocations",
  ])
}

resource "aws_lambda_permission" "apigw_versioned_test" {
  statement_id  = "AllowAPIGatewayVersionedTest"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.versioned.function_name
  qualifier     = aws_lambda_alias.test.name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"

  depends_on = [aws_lambda_alias.test]
}

resource "aws_lambda_permission" "apigw_versioned_prod" {
  statement_id  = "AllowAPIGatewayVersionedProd"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.versioned.function_name
  qualifier     = aws_lambda_alias.prod.name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"

  depends_on = [aws_lambda_alias.prod]
}
