resource "null_resource" "wait_for_nginx" {
    depends_on = [aws_instance.nginx]

    provisioner "local-exec" {
      command = "sleep 90"
    }
}