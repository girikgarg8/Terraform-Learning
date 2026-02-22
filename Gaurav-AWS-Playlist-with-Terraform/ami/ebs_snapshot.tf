resource "aws_ebs_snapshot" "nginx_root" {
  volume_id = aws_instance.nginx.root_block_device[0].volume_id
  description = "Root snapshot of nginx instance for custom AMI"

  tags = {
    Name = "nginx-root-snapshot"
  }

  depends_on = [ null_resource.wait_for_nginx ]
}