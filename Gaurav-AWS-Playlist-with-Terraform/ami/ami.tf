resource "aws_ami" "nginx" {
  name                = "nginx-ami-girik"
  description         = "Custom AMI with nginx pre-installed"
  virtualization_type = "hvm"
  root_device_name    = "/dev/sda1"
  ena_support         = true

  ebs_block_device {
    device_name           = "/dev/sda1"
    snapshot_id           = aws_ebs_snapshot.nginx_root.id
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  tags = {
    Name = "custom-nginx-ami"
  }
}