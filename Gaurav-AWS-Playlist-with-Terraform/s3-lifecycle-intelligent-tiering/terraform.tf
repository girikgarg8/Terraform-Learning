terraform {
    required_version = "1.5.7" # this cannot be referenced from variable like var.required_version because it is checked first before any variable. So, it has to be hardcoded

    required_providers {
     aws = {
        source = "hashicorp/aws"
        version = "6.27.0"
     } 
    }
}