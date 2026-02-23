resource "aws_network_interface" "sample" {
    subnet_id = tolist(data.aws_subnets.default.ids)[0]
    security_groups = [aws_security_group.allow.id]
    description = "Secondary ENI attached to web instance"

    attachment {
      instance = aws_instance.web.id
      device_index = 1 # Primary = 0 (from instance’s subnet_id); extra ENI = device_index = 1.
    }

    tags = {
      Name = "sample-eni"
    }
}