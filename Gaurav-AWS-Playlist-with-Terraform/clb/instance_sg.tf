resource "aws_security_group" "instances" {
    name = "nginx-instances-sg"
    description = "Allow HTTP only from CLB"
    vpc_id = data.aws_vpc.default.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.clb.id]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "nginx-instances-sg"
    }
}