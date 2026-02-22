output "alb_dns_name" {
    value = aws_lb.main.dns_name
    description = "Use http://<this>/blue/ and http://<this>/green/"
}