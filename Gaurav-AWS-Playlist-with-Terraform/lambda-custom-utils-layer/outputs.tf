output "layer_arn" {
  description = "Custom utils layer version ARN"
  value       = aws_lambda_layer_version.my_utils.arn
}

output "lambda_function_name" {
  description = "Function that imports myutils from the layer"
  value       = aws_lambda_function.with_custom_layer.function_name
}
