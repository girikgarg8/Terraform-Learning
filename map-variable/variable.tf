variable userage {
    type = map
    default = {
        girik = 23
        saurav = 19
    }
}

variable user {
    type = string
}

output printage {
    value = "my name is ${var.user} and my age is ${lookup(var.userage, "${var.user}")}"
}