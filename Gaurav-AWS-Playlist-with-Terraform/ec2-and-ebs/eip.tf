resource "aws_eip" "web" {
    instance = aws_instance.web.id
    tags = {
        Name = "eip-for-web"
    }
}