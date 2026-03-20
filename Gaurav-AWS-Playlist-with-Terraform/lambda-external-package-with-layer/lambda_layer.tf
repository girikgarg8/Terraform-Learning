resource "aws_lambda_layer_version" "requests" {
  filename            = "${path.module}/requests_layer.zip"
  layer_name          = "requests-layer"
  compatible_runtimes = ["python3.12"]
  source_code_hash    = filebase64sha256("${path.module}/requests_layer.zip")
}
