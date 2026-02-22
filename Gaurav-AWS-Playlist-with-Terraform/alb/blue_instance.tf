resource "aws_instance" "blue" {
    count = 2
    ami = data.aws_ami.ubuntu_24.id
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = tolist(data.aws_subnets.default.ids)[count.index % length(data.aws_subnets.default.ids)]
    vpc_security_group_ids = [aws_security_group.instances.id]

    user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update && sudo apt-get install -y nginx
    sudo mkdir -p /var/www/html/blue
    echo "I am blue with $(hostname)" | sudo tee /var/www/html/blue/index.html
    echo 'log_format with_xff "$remote_addr - $http_x_forwarded_for - $remote_user [$time_local] \"$request\" $status $body_bytes_sent \"$http_referer\" \"$http_user_agent";' | sudo tee /etc/nginx/conf.d/xff.conf
    sudo sed -i 's/access_log \/var\/log\/nginx\/access.log.*/access_log \/var\/log\/nginx\/access.log with_xff;/' /etc/nginx/sites-available/default
    sudo systemctl enable nginx && sudo systemctl reload nginx
    EOF

    tags = { Name = "blue-${count.index + 1}" }
}