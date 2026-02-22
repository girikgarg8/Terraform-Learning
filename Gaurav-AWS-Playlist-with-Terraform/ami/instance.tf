resource "aws_instance" "nginx" {
    ami = data.aws_ami.ubuntu_24.id
    instance_type = var.instance_type
    key_name = var.key_name

    root_block_device {
        volume_size = 20
        volume_type = "gp3"
    }

    user_data = <<-EOF
        #!/bin/bash
        set -e
        sudo apt-get update && sudo apt-get install -y nginx
        sudo systemctl enable nginx
        sudo systemctl start nginx
    EOF

    tags = {
        Name = "nginx-for-ami"
    }
}