terraform {
    backend "s3" {
      bucket = "girik-tf-state"
      region = "ap-south-1"
      key = "terraform.tfstate"
      dynamodb_table = "girik-terraform-lock-table" # name of dynamo db table that is used to store lock information
    }
}

variable "access_key" {
    type = string
}

variable "secret_key" {
  type = string
}

provider "aws" {
    region = "ap-south-1"
    access_key = var.access_key
    secret_key = var.secret_key
}

resource "aws_instance" "web" {
  ami = var.ami
  instance_type = var.instance_type
}