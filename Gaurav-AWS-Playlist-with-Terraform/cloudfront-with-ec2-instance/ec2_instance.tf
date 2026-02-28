data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "nginx" {
  ami = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  subnet_id = tolist(data.aws_subnets.default.ids)[0]
  vpc_security_group_ids = [aws_security_group.nginx.id]
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install nginx1 -y
    sudo systemctl enable nginx
    sudo systemctl start nginx
    EOF
}