resource "aws_instance" "example" {
  ami = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_full_access.name
  key_name = var.key_name

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y aws-cli
  EOF
    
}