data "aws_iam_policy_document" "replication" {
    statement {
      sid = "SourceBucket"
      effect = "Allow"
      actions = [
        "s3:GetReplicationConfiguration",
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl",
        "s3:GetObjectVersionTagging",
        "s3:GetObjectVersion"
      ]

      resources = ["${aws_s3_bucket.source.arn}/*"]
    }

    statement {
      sid = "DestinationBucket"
      effect = "Allow"
      actions = [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ]

      resources = ["${aws_s3_bucket.destination.arn}/*"]
    }
}

resource "aws_iam_role_policy" "replication" {
    name = "s3-replication-policy"
    role = aws_iam_role.replication.id
    policy = data.aws_iam_policy_document.replication.json
}