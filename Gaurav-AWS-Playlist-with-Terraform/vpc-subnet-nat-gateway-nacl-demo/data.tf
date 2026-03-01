data "aws_availability_zones" "available" {
    state = "available"
}

data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }
    filter {
      name = "state"
      values = ["available"]
    }
}

data "aws_ami" "fck_nat" {
    most_recent = true
    owners = ["568608671756"]
    filter {
        name   = "name"
        values = ["fck-nat-al2023-*x86_64-ebs"]
    }
}