resource "aws_ebs_volume" "data" {
    availability_zone = aws_instance.web.availability_zone
    size = 30
    type = "gp3"

    tags = {
        Name = "data-volume"
        SnapshotLifecycle = "daily"
    }
}

resource "aws_volume_attachment" "data" {
    device_name = "/dev/sdf"
    instance_id = aws_instance.web.id
    volume_id = aws_ebs_volume.data.id
}