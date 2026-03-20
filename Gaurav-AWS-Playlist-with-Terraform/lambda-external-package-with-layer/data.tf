data "archive_file" "function_zip" {
  type        = "zip"
  source_file = "${path.module}/index.py"
  output_path = "${path.module}/code_only.zip"
}
