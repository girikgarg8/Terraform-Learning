resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu_24.id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "ec2-with-eip-ebs"
  }
}   