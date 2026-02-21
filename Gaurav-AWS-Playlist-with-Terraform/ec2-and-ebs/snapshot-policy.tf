resource "aws_dlm_lifecycle_policy" "ebs_daily" {
    description = "Daily EBS snapshot lifecycle"
    execution_role_arn = aws_iam_role.dlm_lifecycle.arn
    state = "ENABLED"

    policy_details {
      resource_types = ["VOLUME"]

      schedule {
        name = "Daily snapshots"

        create_rule {
          interval = 24
          interval_unit = "HOURS"
          times = ["03:00"]
        }

        retain_rule {
          count = 7
        }

        tags_to_add = {
          SnapshotType = "automated"
        }
      }

      target_tags = {
        SnapshotLifecycle = "daily"
      }
    }
}