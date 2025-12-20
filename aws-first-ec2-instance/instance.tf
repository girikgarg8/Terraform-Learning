resource "aws_instance" "web" {
  ami           = var.image_id
  instance_type = var.instance_type

  key_name = aws_key_pair.key-tf.key_name

  vpc_security_group_ids = ["${aws_security_group.tf-security-group.id}"]

  tags = {
    Name = "first-tf-instance"
  }

  user_data = file("script.sh")

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("id_rsa")
    host        = self.public_ip
    # cannot use aws_instance.web.public_ip since it would lead to cyclic dependency. 
    # aws_instance.web would be dependent on connection and connection would be dependent on aws_instance.web.public_ip
  }

  provisioner "file" {
    source      = "README.md"      # terraform machine
    destination = "/tmp/README.md" # remote machine
  }

  provisioner "file" {
    content     = "Hello, this is a sample content" # terraform machine
    destination = "/tmp/content.md"                 # remote machine
  }

  # local-exec runs command on local machine (where terraform commands are run) while remote-exec runs on the remote resource like EC2 instance

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ip_address.txt"
  }

  provisioner "local-exec" {
    working_dir = "/tmp/"
    command     = "echo ${self.public_ip} > mypublicipintmp.txt"
  }

  provisioner "local-exec" {
    interpreter = ["/usr/local/bin/python3", "-c"]
    command     = "print('HelloWorld')"
  }

  provisioner "local-exec" {
    command = "env>env.txt" //write the environment variables to a file 'env.txt' on local to check if the env variable 'envname' got exported
    environment = {
      envname = "envvalue"
    }
  }

  provisioner "local-exec" {
    command = "echo 'at Create'"
  }

  provisioner "local-exec" {
    when = destroy
    command = "echo 'at delete'"
  }
}