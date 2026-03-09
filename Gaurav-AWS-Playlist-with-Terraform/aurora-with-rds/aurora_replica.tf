resource "aws_security_group" "replica_cluster" {
  provider = aws.replica

  name_prefix = "aurora-replica-"
  description = "Aurora MySQL cross-region replica"
  vpc_id = aws_vpc.replica.id

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = [var.replica_vpc_cidr, data.aws_vpc.default_primary.cidr_block]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_rds_cluster" "replica" {
  provider = aws.replica

  cluster_identifier              = var.cluster_identifier_replica
  replication_source_identifier   = aws_rds_cluster.primary.arn
  engine                           = aws_rds_cluster.primary.engine
  db_subnet_group_name             = aws_db_subnet_group.replica.name
  vpc_security_group_ids           = [aws_security_group.replica_cluster.id]
  skip_final_snapshot              = true

  depends_on = [
    aws_rds_cluster_instance.primary_writer,
    aws_rds_cluster_instance.primary_reader,
    aws_vpc_peering_connection_accepter.replica,
  ]
}

resource "aws_rds_cluster_instance" "replica" {
  provider = aws.replica

  identifier = "${var.cluster_identifier_replica}-instance"
  cluster_identifier = aws_rds_cluster.replica.id
  instance_class = var.aurora_instance_class
  engine = aws_rds_cluster.replica.engine
  engine_version = aws_rds_cluster.replica.engine_version

}