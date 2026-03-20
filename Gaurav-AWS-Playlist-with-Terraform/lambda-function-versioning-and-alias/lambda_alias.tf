# "test" alias:
# - Split OFF: points at the latest published version only.
# - Split ON:  primary_version gets (1 - secondary_weight), secondary_version gets secondary_weight (e.g. 50/50).
resource "aws_lambda_alias" "test" {
  name             = "test"
  function_name    = aws_lambda_function.versioned.function_name
  function_version = var.test_traffic_split_enabled ? var.test_traffic_primary_version : aws_lambda_function.versioned.version

  dynamic "routing_config" {
    for_each = var.test_traffic_split_enabled ? [1] : []
    content {
      additional_version_weights = {
        (var.test_traffic_secondary_version) = var.test_traffic_secondary_weight
      }
    }
  }
}

# "prod" stays on a version you promote explicitly (variable).
resource "aws_lambda_alias" "prod" {
  name             = "prod"
  function_name    = aws_lambda_function.versioned.function_name
  function_version = var.prod_alias_version
}
