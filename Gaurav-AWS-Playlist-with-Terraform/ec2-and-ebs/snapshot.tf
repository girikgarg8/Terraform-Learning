resource "aws_ebs_snapshot" "data_backup" {
    volume_id = aws_ebs_volume.data.id
    description = "Ad-hoc snapshot of data volume"

    tags = {
        Name = "data-volume-adhoc-snapshot"
    }
}