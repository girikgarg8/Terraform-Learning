resource "aws_kms_key" "rds" {
  description = "KMS key for RDS MariaDB encryption"
  deletion_window_in_days = 7
  enable_key_rotation = true
  tags = {
    Name = "mariadb-rds-key"
  }
}

resource "aws_kms_alias" "rds" {
  name = "alias/mariadb-rds"
  target_key_id = aws_kms_key.rds.key_id
}