resource "aws_lb_target_group" "blue" {
    name = "blue-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id
    health_check {
        path = "/blue/"
        matcher = "200"
        interval = 30
        timeout = 5
        healthy_threshold = 2
        unhealthy_threshold = 2
    }

    # uncomment to see stickiness in action
    stickiness { 
        type = "lb_cookie"
        cookie_duration = 86400
        enabled = true 
    }

    tags = {
        Name = "blue-tg"
    }
}

resource "aws_lb_target_group" "green" {
    name = "green-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id
    health_check {
        path = "/green/"
        matcher = "200"
        interval = 30
        timeout = 5
        healthy_threshold = 2
        unhealthy_threshold = 2
    }

    tags = {
        Name = "green-tg"
    }
}