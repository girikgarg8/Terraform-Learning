# On-Premises Instance (ap-south-1) - Acts as VPN endpoint with Libreswan
resource "aws_instance" "on_premises_instance" {
  provider                    = aws.on_premises
  ami                         = data.aws_ami.amazon_linux_on_premises.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.on_premises_public.id
  vpc_security_group_ids      = [aws_security_group.on_premises_sg.id]
  source_dest_check           = false  # Important for VPN functionality
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y libreswan
    
    # Configure IP forwarding
    echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
    echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
    echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.conf
    sysctl -p
    
    # Create directory for configuration
    mkdir -p /etc/ipsec.d
    
    # Note: VPN configuration will be provided in outputs
    # Manual configuration required after deployment
  EOF

  tags = {
    Name = "on-premises-instance"
    Type = "VPN-Gateway-Simulation"
  }
}

# AWS Cloud Instance (ap-south-2) - Target for VPN connectivity
resource "aws_instance" "aws_instance" {
  provider               = aws.aws_cloud
  ami                    = data.aws_ami.amazon_linux_aws_cloud.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = aws_subnet.aws_cloud_private.id
  vpc_security_group_ids = [aws_security_group.aws_cloud_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    
    # Install basic tools
    yum install -y telnet nc
  EOF

  tags = {
    Name = "aws-instance"
    Type = "Production-Workload"
  }
}

# Bastion Host in AWS Cloud (ap-south-2) - For troubleshooting
resource "aws_instance" "aws_bastion" {
  provider                    = aws.aws_cloud
  ami                         = data.aws_ami.amazon_linux_aws_cloud.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.aws_cloud_public.id
  vpc_security_group_ids      = [aws_security_group.aws_cloud_bastion_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y telnet nc
  EOF

  tags = {
    Name = "aws-bastion"
    Type = "Management"
  }
}