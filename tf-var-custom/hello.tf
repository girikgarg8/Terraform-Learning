variable user {
    type = string
}

variable age {
    type = number
}

output print {
    value = "Hi, your name is ${var.user} and age is ${var.age}"
}