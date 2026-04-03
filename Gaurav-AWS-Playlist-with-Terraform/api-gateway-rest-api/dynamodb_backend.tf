resource "aws_dynamodb_table" "items" {
  name = "playlist-items"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "pk"
  attribute {
    name = "pk"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "sample" {
  table_name = aws_dynamodb_table.items.name
  hash_key = aws_dynamodb_table.items.hash_key
  item = jsonencode({
    pk = {
        S = "user-1"
    },
    name = {
        S = "Alice"
    }
  })
}

resource "aws_iam_role" "apigw_db" {
  name = "playlist-apigw-db"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow"
        Principal = {
            Service = "apigateway.amazonaws.com"
        }
        Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "apigw_ddb" {
  name = "ddb-query"
  role = aws_iam_role.apigw_db.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow"
        Action = ["dynamodb:Query"]
        Resource = aws_dynamodb_table.items.arn
    }]
  })
}

resource "aws_api_gateway_resource" "ddb" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id = aws_api_gateway_rest_api.main.root_resource_id
  path_part = "ddb"
}

resource "aws_api_gateway_method" "ddb_post" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.ddb.id
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "ddb_query" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.ddb.id
  http_method = aws_api_gateway_method.ddb_post.http_method
  type = "AWS"
  integration_http_method = "POST"
  credentials = aws_iam_role.apigw_db.arn
  uri = "arn:aws:apigateway:${var.aws_region}:dynamodb:action/Query"
  request_templates = {
    "application/json" = <<-EOT
    {
        "TableName": "${aws_dynamodb_table.items.name}",
        "KeyConditionExpression": "pk = :pk",
        "ExpressionAttributeValues": {
        ":pk": { "S": "$util.escapeJavaScript($input.path('$.partitionKey'))" }
    }
  }
  EOT
  }
}

resource "aws_api_gateway_method_response" "ddb_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.ddb.id
  http_method = aws_api_gateway_method.ddb_post.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "ddb_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.ddb.id
  http_method = aws_api_gateway_method.ddb_post.http_method
  status_code = aws_api_gateway_method_response.ddb_200.status_code
  depends_on  = [aws_api_gateway_integration.ddb_query]
  response_templates = {
    "application/json" = "$input.json('$')"
  }
}