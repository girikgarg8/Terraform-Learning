resource "aws_instance" "nginx" {
    count = 2
    ami = data.aws_ami.ubuntu_24.id
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = tolist(data.aws_subnets.default.ids)[count.index % length(data.aws_subnets.default.ids)]
    vpc_security_group_ids = [aws_security_group.instances.id]

    user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update && sudo apt-get install nginx -y
    sudo systemctl enable nginx && sudo systemctl start nginx
    echo "Hello from instance $(hostname)" | sudo tee /var/www/html/index.html
    EOF

    tags = {
        Name = "nginx-${count.index+1}"
    }
}