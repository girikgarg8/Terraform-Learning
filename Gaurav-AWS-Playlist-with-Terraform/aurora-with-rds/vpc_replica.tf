resource "aws_vpc" "replica" {
  provider = aws.replica
  cidr_block = var.replica_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "aurora-replica-vpc"
  }
}

resource "aws_subnet" "replica_private" {
  provider = aws.replica

  count = length(var.replica_private_subnet_cidrs)
  vpc_id = aws_vpc.replica.id
  cidr_block = var.replica_private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.replica.names[count.index]
  tags = {
    "Name" = "aurora-replica-private-${count.index + 1}"
  }
}

resource "aws_db_subnet_group" "replica" {
  provider = aws.replica

  name = "aurora-mysql-replica-subnet-group"
  subnet_ids = aws_subnet.replica_private[*].id
  tags = {
    Name = "aurora-mysql-replica-subnet-group"
  }
}