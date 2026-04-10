data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  filter {
    name = "default-for-az"
    values = ["true"]
  }
}

data "aws_security_group" "default" {
  name = "default"
  vpc_id = data.aws_vpc.default.id
}

data "aws_ssm_parameter" "ecs_al2023_ami" {
    name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended/image_id"
}