resource "aws_iam_role" "ecs_infrastructure" {
  name = "ecs-infrastructure-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Effect = "Allow"
        Principal = {
            Service = "ecs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_infrastructure_managed" {
  role       = aws_iam_role.ecs_infrastructure.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECSInfrastructureRolePolicyForManagedInstances"
}

# Managed Instances launches EC2 with an instance profile whose role is ecs-instance-role.
# The AWS managed policy above does not grant iam:PassRole on that role; without this, RunInstances fails.
resource "aws_iam_role_policy" "ecs_infrastructure_pass_instance_role" {
  name = "PassEcsInstanceRoleForManagedInstances"
  role = aws_iam_role.ecs_infrastructure.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PassInstanceRole"
        Effect = "Allow"
        Action = "iam:PassRole"
        Resource = [
          data.aws_iam_role.ecs_instance.arn,
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:instance-profile/${var.ecs_instance_profile_name}"
        ]
      }
    ]
  })
}