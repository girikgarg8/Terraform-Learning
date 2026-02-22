resource "aws_security_group" "alb" {
    name = "alb-sg"
    description = "Allow HTTP to ALB"
    vpc_id = data.aws_vpc.default.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "alb-sg"
    }
}

resource "aws_security_group" "instances" {
    name = "blue-green-instance-sg"
    description = "Allow HTTP only from ALB"
    vpc_id = data.aws_vpc.default.id

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.alb.id]
    }

    egress  {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "blue-green-instance-sg"
    }
}