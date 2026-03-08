resource "aws_db_subnet_group" "main" {
  name = "mariadb-demo-subnet-group"
  subnet_ids = aws_subnet.private[*].id
  tags = {
    Name = "mariadb-demo-subnet-group"
  }
}

resource "aws_db_instance" "master" {
  identifier = "mariadb-demo"
  engine = "mariadb"
  engine_version = "11.8.5"

  instance_class = var.db_instance_class
  allocated_storage = var.db_allocated_storage_gb
  storage_type = "gp2"
  storage_encrypted = true
  kms_key_id = aws_kms_key.rds.arn

  db_name = var.db_name
  username = var.master_username
  password = var.master_password

  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible = false
  multi_az = true
  parameter_group_name = "default.mariadb11.8"

  performance_insights_enabled          = true
  performance_insights_retention_period  = 15 * 31
  performance_insights_kms_key_id        = data.aws_kms_key.rds_pi.arn

  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_enhanced_monitoring.arn
  enabled_cloudwatch_logs_exports = []

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "mon:04:00-mon:05:00"
  deletion_protection     = false
  skip_final_snapshot     = true

  tags = {
    Name = "mariadb-demo"
  }
}

resource "aws_db_instance" "replica" {
  identifier              = "mariadb-demo-replica"
  replicate_source_db     = aws_db_instance.master.arn
  instance_class          = var.db_instance_class
  db_subnet_group_name    = aws_db_subnet_group.main.name
  publicly_accessible     = false
  vpc_security_group_ids  = [aws_security_group.rds_replica.id]
  storage_encrypted       = true
  kms_key_id              = aws_kms_key.rds.arn

  performance_insights_enabled          = true
  performance_insights_retention_period = 15 * 31
  performance_insights_kms_key_id       = data.aws_kms_key.rds_pi.arn

  monitoring_interval   = 60
  monitoring_role_arn  = aws_iam_role.rds_enhanced_monitoring.arn
  skip_final_snapshot   = true

  tags = {
    Name = "mariadb-demo-replica"
  }
}