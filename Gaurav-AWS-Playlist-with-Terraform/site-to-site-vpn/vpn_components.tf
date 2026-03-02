# Virtual Private Gateway (VGW) in AWS Cloud region
resource "aws_vpn_gateway" "aws_cloud_vgw" {
  provider = aws.aws_cloud
  vpc_id   = aws_vpc.aws_cloud.id

  tags = {
    Name = "AWS-Cloud-VGW"
  }
}

# Customer Gateway pointing to on-premises instance
resource "aws_customer_gateway" "on_premises_cgw" {
  provider   = aws.aws_cloud
  bgp_asn    = 65000
  ip_address = aws_instance.on_premises_instance.public_ip
  type       = "ipsec.1"

  tags = {
    Name = "On-Premises-CGW"
  }

  depends_on = [aws_instance.on_premises_instance]
}

# Site-to-Site VPN Connection
resource "aws_vpn_connection" "main" {
  provider            = aws.aws_cloud
  customer_gateway_id = aws_customer_gateway.on_premises_cgw.id
  type                = "ipsec.1"
  vpn_gateway_id      = aws_vpn_gateway.aws_cloud_vgw.id
  static_routes_only  = true

  tags = {
    Name = "On-Premises-to-AWS-VPN"
  }
}

# Static route for on-premises network
resource "aws_vpn_connection_route" "on_premises" {
  provider               = aws.aws_cloud
  vpn_connection_id      = aws_vpn_connection.main.id
  destination_cidr_block = var.on_premises_cidr
}

# Enable route propagation on AWS Cloud private route table
resource "aws_vpn_gateway_route_propagation" "aws_cloud_private" {
  provider       = aws.aws_cloud
  vpn_gateway_id = aws_vpn_gateway.aws_cloud_vgw.id
  route_table_id = aws_route_table.aws_cloud_private.id
}

# Add route to on-premises network in AWS Cloud private route table
resource "aws_route" "aws_cloud_to_on_premises" {
  provider               = aws.aws_cloud
  route_table_id         = aws_route_table.aws_cloud_private.id
  destination_cidr_block = var.on_premises_cidr
  gateway_id             = aws_vpn_gateway.aws_cloud_vgw.id

  depends_on = [aws_vpn_connection.main]
}

# Note: Route to AWS Cloud network is handled by Libreswan IPsec tunnel
# No explicit route needed in on-premises route table as traffic will be 
# encrypted and routed through the VPN tunnel by Libreswan