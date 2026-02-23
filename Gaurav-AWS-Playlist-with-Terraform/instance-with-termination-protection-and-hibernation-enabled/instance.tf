resource "aws_instance" "protected" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = tolist(data.aws_subnets.default.ids)[0]
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]

    # Termination protection: cannot terminate via API/Console (only after disabling)
    disable_api_termination = true

    # Hibernation: instance can be hibernated (need to make sure EBS volume is large enough to handle RAM size, since during hibernation RAM contents are swapped to hard disk)
     hibernation = true

     root_block_device {
       volume_size = 20
       volume_type = "gp3"
     }

    tags = {
      Name = "protected-hibernation-instance"
    }
}