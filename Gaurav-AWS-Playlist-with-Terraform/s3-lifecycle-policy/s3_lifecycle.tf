# S3 Lifecycle Configuration (bucket must have versioning enabled).
# Example: object with v1, v2, v3 (v3 = current). See inline comments for flow.

resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = var.bucket_name

  rule {
    id     = "lifecycle-all-actions"
    status = "Enabled"
    filter {} # whole bucket, or use prefix { prefix = "logs/" }

    # Move current version to cheaper storage. (v1,v2,v3 → v3 is current; v3 moves after 30d.)
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # Move old versions to Glacier. (v1, v2 noncurrent → move to GLACIER after 60d.)
    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }

    # "Expire" current version: S3 adds a DELETE MARKER as new current; v3 becomes noncurrent.
    # (v1,v2 already gone; now current = delete marker, noncurrent = v3.)
    expiration {
      days = 90
    }

    # Permanently delete old versions. (v1, v2 deleted first; then v3 after it becomes noncurrent.)
    # After this, only the delete marker is left for that key.
    noncurrent_version_expiration {
      noncurrent_days = 120
    }

    # Abort incomplete multipart uploads after 7 days (unrelated to v1/v2/v3).
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  # Remove the orphaned delete marker once no object versions remain (v1,v2,v3 all gone).
  # Must be separate rule; no "days" for the marker—removed within ~24–48h when eligible.
  rule {
    id     = "cleanup-delete-markers"
    status = "Enabled"
    filter {}

    expiration {
      expired_object_delete_marker = true
    }
  }
}