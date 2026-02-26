resource "aws_s3_bucket_replication_configuration" "source" {
  bucket = aws_s3_bucket.source.id
  role = aws_iam_role.replication.arn

  rule {
    id = "replicate-all"
    status = "Enabled"

    filter {}

    delete_marker_replication {
      status = "Enabled"
    }
    
    destination {
      bucket = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"

      metrics {
        status = "Enabled"
      }
    }
  }

  depends_on = [ aws_s3_bucket_versioning.source, aws_s3_bucket_versioning.destination ]
}