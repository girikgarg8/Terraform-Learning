resource "aws_security_group" "nginx" {
  name = "nginx-cloudfront-only"
  description = "Allow HTTP/HTTPS only from Cloudfront"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "HTTP from Cloudfront"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    prefix_list_ids = [data.aws_ec2_managed_prefix_list.cloudfront.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}