# EC2: Ubuntu + Docker + app container (host port 80 -> container 3000)
resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.first_public.id
  vpc_security_group_ids = [aws_security_group.app.id]
  associate_public_ip_address = true
  key_name = var.key_name
  
  user_data_base64 = base64encode(templatefile("${path.module}/user_data.sh", {
    docker_image = var.docker_image
  }))

  tags = {
    Name = "${var.project_name}-app"
  }
}
