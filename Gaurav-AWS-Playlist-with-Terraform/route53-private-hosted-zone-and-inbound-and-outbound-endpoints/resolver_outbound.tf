resource "aws_security_group" "outbound_resolver" {
  name_prefix = "resolver-outbound-"
  vpc_id = data.aws_vpc.default.id
  description = "Resolver outbound endpoint: DNS to test-VPC inbound"
 
   ingress {
     from_port = 53
     to_port = 53
     protocol = "udp"
     cidr_blocks = [data.aws_vpc.default.cidr_block]
   }

   ingress {
     from_port = 53
     to_port = 53
     protocol = "tcp"
     cidr_blocks = [data.aws_vpc.default.cidr_block]
   }

   egress {
    from_port = 53
     to_port = 53
     protocol = "tcp"
     cidr_blocks = [var.test_vpc_cidr]
   }

   egress {
    from_port = 53
     to_port = 53
     protocol = "udp"
     cidr_blocks = [var.test_vpc_cidr]
   }

   lifecycle {
     create_before_destroy = true
   }
}

resource "aws_route53_resolver_endpoint" "outbound" {
  name = "default-vpc-outbound"
  direction = "OUTBOUND"
  security_group_ids = [aws_security_group.outbound_resolver.id]

  ip_address {
    subnet_id = tolist(data.aws_subnets.default.ids)[0]
  }

  ip_address {
    subnet_id = tolist(data.aws_subnets.default.ids)[1]
  }
}

resource "aws_route53_resolver_rule" "forward_private_zone" {
  name                 = "forward-${replace(var.private_zone_name, ".", "-")}"
  domain_name          = var.private_zone_name
  rule_type            = "FORWARD"
  resolver_endpoint_id  = aws_route53_resolver_endpoint.outbound.id

  dynamic "target_ip" {
    for_each = aws_route53_resolver_endpoint.inbound.ip_address
    content {
      ip   = target_ip.value.ip
      port = 53
    }
  }
  tags = { Name = "forward-${var.private_zone_name}" }
}

resource "aws_route53_resolver_rule_association" "default_vpc" {
  resolver_rule_id = aws_route53_resolver_rule.forward_private_zone.id
  vpc_id           = data.aws_vpc.default.id
}