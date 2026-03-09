resource "aws_rds_cluster_parameter_group" "primary" {
  provider = aws.primary

  name = "aurora-mysql-primary-pg"
  family = "aurora-mysql8.0"
  description = "Aurora MySQL primary - binlog for cross region replica"

  parameter {
    name         = "binlog_format"
    value        = "MIXED"
    apply_method = "pending-reboot"
  }
}

resource "aws_db_subnet_group" "primary" {
  provider = aws.primary

  name = "aurora-mysql-primary-subnet-group"
  subnet_ids = data.aws_subnets.default_primary.ids
  tags = {
    Name = "aurora-mysql-primary-subnet-group"
  }
}

resource "aws_security_group" "primary_cluster" {
  provider = aws.primary

  name_prefix = "aurora-primary-"
  description = "Aurora MySQL primary cluster"
  vpc_id = data.aws_vpc.default_primary.id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [data.aws_vpc.default_primary.cidr_block]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_rds_cluster" "primary" {
  provider = aws.primary

  cluster_identifier              = var.cluster_identifier_primary
  engine                          = "aurora-mysql"
  engine_version                  = data.aws_rds_engine_version.aurora_mysql.version
  database_name                   = "app"
  master_username                 = var.master_username
  master_password                 = var.master_password
  db_subnet_group_name            = aws_db_subnet_group.primary.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.primary.name
  vpc_security_group_ids          = [aws_security_group.primary_cluster.id]
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = ["error"]
}

resource "aws_rds_cluster_instance" "primary_writer" {
  provider = aws.primary

  identifier = "${var.cluster_identifier_primary}-writer"
  cluster_identifier = aws_rds_cluster.primary.id
  instance_class = var.aurora_instance_class
  engine = aws_rds_cluster.primary.engine
  engine_version = aws_rds_cluster.primary.engine_version
}

resource "aws_rds_cluster_instance" "primary_reader" {
  provider = aws.primary

  identifier = "${var.cluster_identifier_primary}-reader"
  cluster_identifier = aws_rds_cluster.primary.id
  instance_class = var.aurora_instance_class
  engine = aws_rds_cluster.primary.engine
  engine_version = aws_rds_cluster.primary.engine_version
}

# Custom endpoint: load balances across readers in ap-south-1 only
resource "aws_rds_cluster_endpoint" "customendpoint_readers" {
  provider = aws.primary

  cluster_identifier = aws_rds_cluster.primary.id
  cluster_endpoint_identifier = "customendpoint-readers"
  custom_endpoint_type = "READER"
}