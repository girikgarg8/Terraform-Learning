resource "aws_instance" "main" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = tolist(data.aws_subnets.default.ids)[0]

  user_data = <<-EOT
        #!/bin/bash
        set -e
        apt-get update -y
        apt-get install -y stress-ng || true
        (sleep 90 && stress-ng --cpu 2 --timeout 600) & 
    EOT

    # & = “run this in the background and return to the shell immediately.”
    
    tags = {
        Name = "cpu-alarm-demo"
    }
}