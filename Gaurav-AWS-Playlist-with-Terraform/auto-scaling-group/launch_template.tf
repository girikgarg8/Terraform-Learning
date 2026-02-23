resource "aws_launch_template" "web" {
  name_prefix   = "web-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web.id]
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
  sudo apt-get update && sudo apt-get install nginx -y
  echo "Hello, my IP is $(hostname)" | sudo tee /var/www/html/index.html
  sudo systemctl enable nginx && sudo systemctl start nginx
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-asg"
    }
  }
}