output "on_premises_instance_public_ip" {
  description = "Public IP of on-premises instance"
  value       = aws_instance.on_premises_instance.public_ip
}

output "on_premises_instance_private_ip" {
  description = "Private IP of on-premises instance"
  value       = aws_instance.on_premises_instance.private_ip
}

output "aws_instance_private_ip" {
  description = "Private IP of AWS cloud instance"
  value       = aws_instance.aws_instance.private_ip
}

output "aws_bastion_public_ip" {
  description = "Public IP of AWS bastion host"
  value       = aws_instance.aws_bastion.public_ip
}

output "vpn_connection_id" {
  description = "VPN Connection ID"
  value       = aws_vpn_connection.main.id
}

output "customer_gateway_ip" {
  description = "Customer Gateway IP (On-premises instance public IP)"
  value       = aws_customer_gateway.on_premises_cgw.ip_address
}

output "vpn_tunnel_1_address" {
  description = "VPN Tunnel 1 Address"
  value       = aws_vpn_connection.main.tunnel1_address
}

output "vpn_tunnel_1_preshared_key" {
  description = "VPN Tunnel 1 Pre-shared Key"
  value       = aws_vpn_connection.main.tunnel1_preshared_key
  sensitive   = true
}

output "vpn_tunnel_2_address" {
  description = "VPN Tunnel 2 Address"
  value       = aws_vpn_connection.main.tunnel2_address
}

output "vpn_tunnel_2_preshared_key" {
  description = "VPN Tunnel 2 Pre-shared Key"
  value       = aws_vpn_connection.main.tunnel2_preshared_key
  sensitive   = true
}

# Libreswan Configuration Template
output "libreswan_config_tunnel1" {
  description = "Libreswan configuration for Tunnel 1"
  value = templatefile("${path.module}/templates/libreswan_config.tpl", {
    tunnel_name         = "Tunnel1"
    customer_gateway_ip = aws_customer_gateway.on_premises_cgw.ip_address
    vpn_gateway_ip      = aws_vpn_connection.main.tunnel1_address
    customer_network    = var.on_premises_cidr
    aws_network         = var.aws_cloud_cidr
  })
}

output "libreswan_secrets_tunnel1" {
  description = "Libreswan secrets for Tunnel 1"
  value = templatefile("${path.module}/templates/libreswan_secrets.tpl", {
    customer_gateway_ip = aws_customer_gateway.on_premises_cgw.ip_address
    vpn_gateway_ip      = aws_vpn_connection.main.tunnel1_address
    preshared_key       = aws_vpn_connection.main.tunnel1_preshared_key
  })
  sensitive = true
}

output "setup_instructions" {
  description = "Setup instructions for Libreswan"
  sensitive   = true
  value = <<-EOT
    
    === Site-to-Site VPN Setup Instructions ===
    
    1. SSH to on-premises instance:
       ssh -i your-key.pem ec2-user@${aws_instance.on_premises_instance.public_ip}
    
    2. Create Libreswan configuration:
       sudo tee /etc/ipsec.d/aws.conf << 'EOF'
${templatefile("${path.module}/templates/libreswan_config.tpl", {
    tunnel_name         = "Tunnel1"
    customer_gateway_ip = aws_customer_gateway.on_premises_cgw.ip_address
    vpn_gateway_ip      = aws_vpn_connection.main.tunnel1_address
    customer_network    = var.on_premises_cidr
    aws_network         = var.aws_cloud_cidr
  })}
       EOF
    
    3. Create secrets file:
       sudo tee /etc/ipsec.d/aws.secrets << 'EOF'
${templatefile("${path.module}/templates/libreswan_secrets.tpl", {
    customer_gateway_ip = aws_customer_gateway.on_premises_cgw.ip_address
    vpn_gateway_ip      = aws_vpn_connection.main.tunnel1_address
    preshared_key       = aws_vpn_connection.main.tunnel1_preshared_key
  })}
       EOF
    
    4. Set proper permissions:
       sudo chmod 600 /etc/ipsec.d/aws.secrets
    
    5. Start and enable IPsec:
       sudo systemctl start ipsec
       sudo systemctl enable ipsec
    
    6. Check status:
       sudo ipsec status
    
    7. Test connectivity:
       ping ${aws_instance.aws_instance.private_ip}
    
    8. From AWS bastion, test reverse connectivity:
       ssh -i your-key.pem ec2-user@${aws_instance.aws_bastion.public_ip}
       ping ${aws_instance.on_premises_instance.private_ip}
    
    === Key Information ===
    On-Premises Instance: ${aws_instance.on_premises_instance.public_ip} (${aws_instance.on_premises_instance.private_ip})
    AWS Instance: ${aws_instance.aws_instance.private_ip}
    AWS Bastion: ${aws_instance.aws_bastion.public_ip}
    VPN Tunnel 1: ${aws_vpn_connection.main.tunnel1_address}
    
  EOT
}