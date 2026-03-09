resource "aws_vpc_peering_connection" "primary_to_replica" {
  provider = aws.primary

  vpc_id = data.aws_vpc.default_primary.id
  peer_vpc_id = aws_vpc.replica.id
  peer_region = "ap-south-2"
  auto_accept = false
  tags = {
    Name = "primary-to-replica"
  }
}

resource "aws_vpc_peering_connection_accepter" "replica" {
  provider = aws.replica
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_replica.id
  auto_accept = true
}

resource "aws_route" "primary_to_replica" {
  provider = aws.primary

  route_table_id = data.aws_vpc.default_primary.main_route_table_id
  destination_cidr_block = var.replica_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_replica.id
}

resource "aws_route" "replica_to_primary" {
  provider = aws.replica

  route_table_id            = aws_vpc.replica.main_route_table_id
  destination_cidr_block    = data.aws_vpc.default_primary.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_replica.id
}
