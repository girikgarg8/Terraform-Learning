# MariaDB requires client_password_auth_type = "MYSQL_NATIVE_PASSWORD" (set at creation for fresh apply).
resource "aws_db_proxy" "mariadb" {
  name          = "mariadb-proxy"
  engine_family = "MYSQL"

  auth {
    auth_scheme               = "SECRETS"
    secret_arn                = aws_secretsmanager_secret.rds_proxy.arn
    iam_auth                  = "DISABLED"
    client_password_auth_type  = "MYSQL_NATIVE_PASSWORD"
  }

  role_arn = aws_iam_role.rds_proxy.arn
  vpc_subnet_ids = aws_subnet.private[*].id
  vpc_security_group_ids = [aws_security_group.rds_proxy.id]

  require_tls = false
  idle_client_timeout = 30 * 60
  debug_logging = false

  tags = {
    Name = "mariadb-proxy"
  }
}

resource "aws_db_proxy_default_target_group" "mariadb" {
  db_proxy_name = aws_db_proxy.mariadb.name
}

resource "aws_db_proxy_target" "master" {
  db_proxy_name          = aws_db_proxy.mariadb.name
  target_group_name      = aws_db_proxy_default_target_group.mariadb.name
  db_instance_identifier = aws_db_instance.master.identifier

  # Ensure master is available before registering (avoids target registration race).
  depends_on = [aws_db_instance.master]
}