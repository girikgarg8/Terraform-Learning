resource "aws_backup_vault" "dynamodb" {
  name = "dynamodb-backup-vault"
}

resource "aws_backup_plan" "dynamodb" {
  name = "dynamodb-backup-plan"

  rule {
    rule_name = "daily_dynamodb"
    target_vault_name = aws_backup_vault.dynamodb.name
    schedule = "cron(0 5 * * ? *)" # daily 05:00 UTC

    lifecycle {
      delete_after = 2
    }

    copy_action {
      destination_vault_arn = aws_backup_vault.dynamodb.arn
      lifecycle {
        delete_after = 2
      }
    }
  }
}

resource "aws_backup_selection" "dynamodb" {
  name = "dynamodb-selection"
  plan_id = aws_backup_plan.dynamodb.id
  iam_role_arn = aws_iam_role.backup.arn

  selection_tag {
    type = "STRINGEQUALS"
    key = "backup"
    value = "true"
  }

  resources = [aws_dynamodb_table.main.arn]
}

resource "aws_iam_role" "backup" {
  name = "aws-backup-dynamodb-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "backup.amazonaws.com"
        }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "backup" {
  role = aws_iam_role.backup.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}