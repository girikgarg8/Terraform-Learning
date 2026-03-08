# Use a unique name
# Name must be unique; previous secret may be in 30-day recovery after destroy
resource "aws_secretsmanager_secret" "rds_proxy" {
  name        = "test/mariadb-rds-proxy-v2"
  description = "Master credentials for RDS proxy"
}

resource "aws_secretsmanager_secret_version" "rds_proxy" {
  secret_id = aws_secretsmanager_secret.rds_proxy.id
  secret_string = jsonencode({
    username = var.master_username
    password = var.master_password
  })
}