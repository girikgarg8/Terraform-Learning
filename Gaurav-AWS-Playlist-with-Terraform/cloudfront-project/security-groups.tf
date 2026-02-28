# Allow HTTP from internet (CloudFront and direct access for demo)
resource "aws_security_group" "app" {
  name_prefix = "${var.project_name}-"
  description = "Allow HTTP for CloudFront origin and demo access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from anywhere (CloudFront + demo)"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound"
  }

  lifecycle {
    create_before_destroy = true
  }
}
