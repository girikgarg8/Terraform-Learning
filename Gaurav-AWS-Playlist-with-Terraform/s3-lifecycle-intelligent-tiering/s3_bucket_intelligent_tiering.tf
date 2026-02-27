resource "aws_s3_bucket_intelligent_tiering_configuration" "archive" {
  bucket = var.s3_bucket_name

  name = "ArchiveAndDeepArchive"

  # Empty prefix = all objects in bucket (provider requires prefix or tags)
  filter {
    prefix = ""
  }

  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days = 90
  }

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days = 180
  }
}