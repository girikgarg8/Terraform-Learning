# Wait for AMI to become available (AWS creates it asynchronously)
resource "null_resource" "wait_ami_available" {
  depends_on = [aws_ami.nginx]

  provisioner "local-exec" {
    command = "sleep 45"
  }
}

resource "aws_instance" "from_nginx_ami" {
  ami           = aws_ami.nginx.id
  instance_type = var.instance_type
  key_name      = var.key_name

  depends_on = [null_resource.wait_ami_available]

  tags = {
    Name = "from-nginx-ami"
  }
}