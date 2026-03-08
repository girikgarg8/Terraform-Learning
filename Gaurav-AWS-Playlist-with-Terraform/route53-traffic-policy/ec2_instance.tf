resource "aws_instance" "web" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = tolist(data.aws_subnets.default.ids)[0]
  vpc_security_group_ids = [aws_security_group.web.id]
  user_data_base64 = base64encode(<<-EOF
#!/bin/bash
sudo apt-get update && sudo apt-get install nginx -y
systemctl enable nginx && systemctl start nginx
EOF
  )

  tags = {
    Name = "traffic-policy-web"
  }
}