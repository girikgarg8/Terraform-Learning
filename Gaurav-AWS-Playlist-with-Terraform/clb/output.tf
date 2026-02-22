output "clb_dns" {
    value = aws_elb.nginx.dns_name
    description = "CLB DNS Name - use http://<this> to hit nginx"
}