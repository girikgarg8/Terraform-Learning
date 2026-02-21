output "instance_id" {
    value = aws_instance.web.id
}

output "public_ip" {
    value = aws_eip.web.public_ip
}

output "ebs_volume_id" {
    value = aws_ebs_volume.data.id
}

output "ebs_snapshot_id" {
  value       = aws_ebs_snapshot.data_backup.id
  description = "Ad-hoc EBS snapshot ID"
}