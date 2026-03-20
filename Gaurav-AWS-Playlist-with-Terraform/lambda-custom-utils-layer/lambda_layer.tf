resource "aws_lambda_layer_version" "my_utils" {
  filename            = data.archive_file.custom_layer_zip.output_path
  layer_name          = "my-utils-layer"
  compatible_runtimes = ["python3.12"]
  source_code_hash    = data.archive_file.custom_layer_zip.output_base64sha256
}
