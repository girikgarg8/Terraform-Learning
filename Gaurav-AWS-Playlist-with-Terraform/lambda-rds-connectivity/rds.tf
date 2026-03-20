resource "random_password" "db_master" {
  length  = 16
  special = false
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnets"
  subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]

  tags = {
    Name = "${var.project_name}-db-subnets"
  }
}

# Minimal footprint for faster provisioning: single-AZ, small instance, no backups.
# engine_version omitted so AWS picks an available MySQL 8.0.x in the region.
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-mysql"

  engine          = "mysql"
  instance_class  = "db.t4g.micro"
  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "appdb"
  username = "dbadmin"
  password = random_password.db_master.result

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az                = false
  publicly_accessible     = false
  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false
  apply_immediately       = true

  tags = {
    Name = "${var.project_name}-mysql"
  }
}
