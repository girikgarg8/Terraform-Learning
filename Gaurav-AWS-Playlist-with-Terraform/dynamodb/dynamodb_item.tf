resource "aws_dynamodb_table_item" "item1" {
  table_name = aws_dynamodb_table.main.name
  hash_key = aws_dynamodb_table.main.hash_key
  range_key = aws_dynamodb_table.main.range_key

  item = jsonencode({
    userId    = { S = "USER#1" }
    entityType = { S = "PROFILE" }
    createdAt = { S = "2026-07-08T10:00:00Z" }
    email     = { S = "abc@test.com" }
  })
}