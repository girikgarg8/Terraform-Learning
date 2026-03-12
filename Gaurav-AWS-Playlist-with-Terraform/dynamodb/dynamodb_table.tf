resource "aws_dynamodb_table" "main" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"
  range_key    = "entityType"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  deletion_protection_enabled = true

  attribute {
    name = "userId"
    type = "S" # String
  }

  attribute {
    name = "entityType"
    type = "S"
  }

  # LSI : same partition (userId), sort by createdAt
  attribute {
    name = "createdAt"
    type = "S"
  }

  # GSI: lookup by email, then by userId
  attribute {
    name = "email"
    type = "S"
  }
 
  # Local secondary index (same partition key userId, different sort key createdAt)
  local_secondary_index {
    name            = "lsi_createdAt"
    range_key       = "createdAt"
    projection_type = "ALL"
  }

  # Global secondary index: lookup by email (uses same billing as table when PAY_PER_REQUEST)
  global_secondary_index {
    name            = "gsi_email"
    hash_key        = "email"
    range_key       = "userId"
    projection_type = "ALL"
  }

  point_in_time_recovery {
    enabled = true
  }

  replica {
    region_name = "ap-south-2"
  }

  tags = {
    Name    = var.table_name
    backup  = "true"
  }
}