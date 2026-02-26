data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "replication_assume" {
    statement {
      actions = ["sts:AssumeRole"]
      principals {
        type = "Service"
        identifiers = ["s3.amazonaws.com"]
      }
    }
}

resource "aws_iam_role" "replication" {
  name = "s3-replication-role"
  assume_role_policy = data.aws_iam_policy_document.replication_assume.json
}