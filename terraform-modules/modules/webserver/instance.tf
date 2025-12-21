resource "aws_instance" "web" {
  ami = var.ami_id
  instance_type = var.instance_type
  key_name = aws_key_pair.key-tf.key_name
}