resource "aws_instance" "main" {
  ami           = data.aws_ami.amazon_linux2.id
  instance_type = var.instance_type
  subnet_id     = tolist(data.aws_subnets.default.ids)[0]

  tags = {
    Name = "dashboard-demo-instance"
  }
}
