data "aws_iam_policy_document" "rds_monitoring_assume" {
    statement {
      actions = ["sts:AssumeRole"]
      principals {
        type = "Service"
        identifiers = ["monitoring.rds.amazonaws.com"]
      }
    }
}

resource "aws_iam_role" "rds_enhanced_monitoring" {
   name = "rds-monitoring-role-mariadb"
   assume_role_policy = data.aws_iam_policy_document.rds_monitoring_assume.json
}

resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role = aws_iam_role.rds_enhanced_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_iam_policy_document" "rds_proxy_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_proxy" {
  name = "rds-proxy-role-mariadb"
  assume_role_policy = data.aws_iam_policy_document.rds_proxy_assume.json
}

resource "aws_iam_role_policy" "rds_proxy_secrets" {
  name = "rds-proxy-secrets"
  role = aws_iam_role.rds_proxy.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow"
        Action = ["secretsmanager:GetSecretValue"]
        Resource = [aws_secretsmanager_secret.rds_proxy.arn]
    }]
  })
}