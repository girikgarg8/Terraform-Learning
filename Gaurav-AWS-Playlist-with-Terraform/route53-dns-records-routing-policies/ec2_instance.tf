resource "aws_instance" "web_aps1" {
  provider = aws.aps1
  ami = data.aws_ami.amazon_linux_aps1.id
  instance_type = var.instance_type
  key_name = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.web_aps1.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install nginx1 -y
    systemctl enable nginx && systemctl start nginx
  EOF

  tags = {
    Name = "web-aps1"
  }
}

resource "aws_instance" "web_usw2" {
  provider = aws.usw2
  ami = data.aws_ami.amazon_linux_usw2.id
  instance_type = var.instance_type
  key_name = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.web_usw2.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install nginx1 -y
    systemctl enable nginx && systemctl start nginx
  EOF

  tags = {
    Name = "web-usw2"
  }
}
