resource "aws_lambda_function_url" "test" {
  function_name      = aws_lambda_function.versioned.function_name
  qualifier          = aws_lambda_alias.test.name
  authorization_type = "NONE"

  depends_on = [
    aws_lambda_permission.url_test_invoke_url,
    aws_lambda_permission.url_test_invoke,
  ]
}

resource "aws_lambda_function_url" "prod" {
  function_name      = aws_lambda_function.versioned.function_name
  qualifier          = aws_lambda_alias.prod.name
  authorization_type = "NONE"

  depends_on = [
    aws_lambda_permission.url_prod_invoke_url,
    aws_lambda_permission.url_prod_invoke,
  ]
}
