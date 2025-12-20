

# creating security group with code duplication

# resource "aws_security_group" "tf-security-group" {
#     name = "first-tf-security-group"
#     description = "Allow inbound traffic"


#     ingress {
#         from_port = 22
#         to_port = 22
#         protocol = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     ingress {
#         from_port = 80
#         to_port = 80
#         protocol = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     ingress {
#         from_port = 443
#         to_port = 443
#         protocol = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }
# }


# creating security group with DRY
resource "aws_security_group" "tf-security-group" {
  name        = "first-tf-security-group"
  description = "Allow inbound traffic on different ports"

  dynamic "ingress" {
    for_each = var.ports

    iterator = port

    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0    # when protocol = "-1", use 0 for both from_port and to_port
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}