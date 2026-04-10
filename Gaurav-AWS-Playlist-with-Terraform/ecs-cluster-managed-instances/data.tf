data "aws_caller_identity" "current" {}

data "aws_iam_role" "ecs_instance" {
  name = var.ecs_instance_role_name
}
