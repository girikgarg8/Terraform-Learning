# Layer zip: root must contain python/... (Python layer layout)
data "archive_file" "custom_layer_zip" {
  type        = "zip"
  source_dir  = "${path.module}/layer_content"
  output_path = "${path.module}/custom_utils_layer.zip"
}

# Function deployment package: handler only (imports myutils from layer)
data "archive_file" "function_zip" {
  type        = "zip"
  source_file = "${path.module}/index.py"
  output_path = "${path.module}/code_only.zip"
}
