output printfirst {
    value = "${join("-->", var.users)}"
}

output uppername {
    value = "${lower(var.users[0])}"
}