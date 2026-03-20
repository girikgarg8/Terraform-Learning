# Function URL (NONE) — both permission types are often required
resource "aws_lambda_permission" "url_test_invoke_url" {
  statement_id           = "AllowURLTestInvokeUrl"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.versioned.function_name
  qualifier              = aws_lambda_alias.test.name
  principal              = "*"
  function_url_auth_type = "NONE"
}

resource "aws_lambda_permission" "url_test_invoke" {
  statement_id  = "AllowURLTestInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.versioned.function_name
  qualifier     = aws_lambda_alias.test.name
  principal     = "*"
}

resource "aws_lambda_permission" "url_prod_invoke_url" {
  statement_id           = "AllowURLProdInvokeUrl"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.versioned.function_name
  qualifier              = aws_lambda_alias.prod.name
  principal              = "*"
  function_url_auth_type = "NONE"
}

resource "aws_lambda_permission" "url_prod_invoke" {
  statement_id  = "AllowURLProdInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.versioned.function_name
  qualifier     = aws_lambda_alias.prod.name
  principal     = "*"
}
